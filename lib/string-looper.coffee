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

_iCurrentLoop = 0
_sCurrentWord = null
_rNumberExtractor = /^(-*\d+(\.\d+)?)([a-zA-Z%]+)?$/

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
            oCursorWordRange = oCursor.getCurrentWordBufferRange
                wordRegex: atom.config.get( "string-looper.wordRegex" ) or oCursor.wordRegExp()
            sWord = oCursor.editor.getTextInRange oCursorWordRange

            if aMatching = _rNumberExtractor.exec sWord # it's a number (TODO)
                console.log "number:", sWord, aMatching
                _oPrevCharRange = oCursorWordRange.copy()
                _oPrevCharRange.end.column = _oPrevCharRange.start.column
                _oPrevCharRange.start.column -= 1
                _oNextCharRange = oCursorWordRange.copy()
                _oNextCharRange.start.column = _oNextCharRange.end.column
                _oNextCharRange.end.column += 1
                if oCursor.editor.getTextInRange( _oPrevCharRange ) is "."
                    console.log "extend to left!" # TODO (on the same line only)
                else if oCursor.editor.getTextInRange( _oNextCharRange ) is "."
                    console.log "extend to right!" # TODO (on the same line only)
                sNewWord = sWord
            else if aEnum = _findAnEnum sWord # it's an enum-listed word
                sNewWord = aEnum[ aEnum.indexOf( sWord ) + ( if sDirection is "up" then 1 else -1 ) ] ? aEnum[ if sDirection is "up" then 0 else ( aEnum.length - 1 ) ]
            else # cycle (lowercase/uppercase/camelCase at cursor position)
                if _sCurrentWord isnt sWord.toLowerCase()
                    _iCurrentLoop = switch
                        when sWord.toLowerCase() is sWord then 1
                        when sWord.toUpperCase() is sWord then 2
                        else 0
                    _sCurrentWord = sWord
                switch _iCurrentLoop
                    when 0 # lowerCase
                        sNewWord = sWord.toLowerCase()
                    when 1 # upperCase
                        sNewWord = sWord.toUpperCase()
                    when 2 # camelCase at cursor position
                        iCursorPosition = oCursor.getBufferPosition().column - oCursorWordRange.start.column
                        sNewWord = sWord.slice( 0, iCursorPosition ).toLowerCase() + sWord.slice( iCursorPosition, iCursorPosition + 1 ).toUpperCase() + sWord.slice( iCursorPosition + 1 ).toLowerCase()
                ++_iCurrentLoop > 2 and ( _iCurrentLoop = 0 )

            oEditor.setTextInBufferRange oCursorWordRange, sNewWord

        oEditor.setCursorBufferPosition aCursorPositions[ aCursorPositions.length - 1 ]
