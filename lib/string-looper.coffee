_aEnums = [
    [ "yes", "no" ]
    [ "true", "false" ]
    [ "relative", "absolute", "fixed"  ]
    [ "top", "bottom" ]
    [ "left", "right" ]
    [ "width", "height" ]
    [ "margin", "padding" ]
    [ "block", "none", "inline", "inline-block" ]
    [ "h1", "h2", "h3", "h4", "h5", "h6" ]
    [ "am", "pm" ]
    [ "sun", "mon", "tue", "wed", "thu", "fri", "sat" ]
    [ "sunday", "monday", "tuesday", "wednesday", "thursday", "friday", "saturday" ]
    [ "jan", "feb", "mar", "apr", "may", "jun", "jul", "aug", "sep", "oct", "nov", "dec" ]
    [ "TODO", "DONE", "FIXME" ]
]

aEnums = []

_mergeEnums = ( aEnumsToMerge ) ->
    ( aEnums = _aEnums.concat aEnumsToMerge ).reverse()

_findAnEnum = ( sWord ) ->
    for aEnum in aEnums
        return aEnum if aEnum.indexOf( sWord ) > -1
    no

module.exports =
    config:
        wordRegex:
            title: "Word RegExp"
            description: "A RegExp indicating what constitutes a 'word' (default will use the Atom's built-in Word RegExp)"
            type: "string"
            default: ""
        enums:
            type: "array"
            default: [ [ "yes", "no" ] ]
            items:
                type: "array"

    activate: ->
        _mergeEnums atom.config.get "string-looper.enums"
        atom.config.observe "string-looper.enums", _mergeEnums
        atom.commands.add ".editor:not(.mini)",
            "string-looper:loop-up": => @loop()
            "string-looper:loop-down": => @loop "down"

    loop: ( sDirection = "up" ) ->
        aCursorPositions = ( oEditor = atom.workspace.getActiveTextEditor() ).getCursorBufferPositions()
        for oCursor in oEditor.cursors
            oCursorRange = oCursor.getCurrentWordBufferRange
                wordRegex: atom.config.get( "string-looper.wordRegex" ) or oCursor.wordRegExp()
            sWord = oEditor.getTextInRange oCursorRange

            if no # TODO it's a number
                console.log "it's a number!"
            else if aEnum = _findAnEnum sWord
                sNewWord = aEnum[ aEnum.indexOf( sWord ) + ( if sDirection is "up" then 1 else -1 ) ] ? aEnum[ if sDirection is "up" then 0 else ( aEnum.length - 1 ) ]
            else # cycle (lowercase/uppercase)
                sNewWord = if sWord.toLowerCase() is sWord then sWord.toUpperCase() else sWord.toLowerCase()

            oEditor.setTextInBufferRange oCursorRange, sNewWord

        oEditor.setCursorBufferPosition aCursorPositions[ aCursorPositions.length - 1 ]
