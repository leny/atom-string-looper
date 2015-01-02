# string-looper package

> Change word case, number value and loop between keywords with the arrows of your keyboard.

* * *

**Note:** this package is kinda like in beta: it works in most cases, but in some cases the results can be a little weird. Don't hesitate [creating an issue](https://github.com/leny/atom-string-looper/issues) when you find one.

* * *

## Keymaps

### Looping up

**On Mac OS X:** `alt-up`
**On Windows & Linux:** `alt-up`

### Looping down

**On Mac OS X:** `alt-down`
**On Windows & Linux:** `alt-down`

### Looping up at cursor

**On Mac OS X:** `cmd-alt-up`
**On Windows & Linux:** `cmd-alt-up`

### Looping down at cursor

**On Mac OS X:** `cmd-alt-down`
**On Windows & Linux:** `cmd-alt-down`

## Behaviour

When you trigger the command over a word, it will loop between `lowercase`, `uppercase` and `camelCase` (adding a uppercase letter at cursor position).

![Loop a word](https://raw.githubusercontent.com/leny/atom-string-looper/master/caps/word-looper.gif)

When you trigger the command over certain words, it will loop between numerous possible values, like `yes` and `no`.

![Loop an enum](https://raw.githubusercontent.com/leny/atom-string-looper/master/caps/enum-looper.gif)

The built-in enums are :

* yes, no
* true, false
* relative, absolute, fixed
* top, bottom
* left, right
* width, height
* margin, padding
* block, none, inline, inline-block
* h1, h2, h3, h4, h5, h6
* am, pm
* sun, mon, tue, wed, thu, fri, sat
* sunday, monday, tuesday, wednesday, thursday, friday, saturday
* jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec
* TODO, DONE, FIXME

You can also add your own enums by modifying your `~/.atom/config.cson` file, like this :

```
'string-looper':
  'enums': [
    [
      'oui'
      'non'
    ],
    [
      'am'
      'pm'
    ]
  ]
```

When you trigger the command over a number, it will increment/decrement it by `1`.

![Loop a number](https://raw.githubusercontent.com/leny/atom-string-looper/master/caps/number-looper.gif)

If you use the "(in|de)crement-at-cursor" command, it will increment/decrement it at the point of the cursor.

![Loop a number at the cursor](https://raw.githubusercontent.com/leny/atom-string-looper/master/caps/number-looper-at-cursor.gif)

* * *

## TODO

* [ ] Write complete atom specs
* [ ] Refactor number-loop code
