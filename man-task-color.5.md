# task-color(5) - A color tutorial for the Taskwarrior command line todo manager

## Name

task-color - A color tutorial for the Taskwarrior command line todo manager

## Automatic Monochrome

It should be mentioned that Taskwarrior is aware of whether its output is going to a terminal, or to a file or through a pipe. When Taskwarrior output goes to a terminal, color is desirable, but consider the following command:

```
$ task list > file.txt
```

Do we really want all those color control codes in the file? Taskwarrior assumes that you do not, and temporarily sets color to 'off' while generating the output. This explains the output from the following command:

```
$ task show | grep '^color '
color                        off
```

It always returns 'off', no matter what the setting, because the output is being sent to a pipe.

If you wanted those color codes, you can override this behavior by setting the `_forcecolor` variable to on, like this:

```
$ task config _forcecolor on
$ task config | grep '^color '
color                        on
```

Or by temporarily overriding it like this:

```
$ task rc._forcecolor=on config | grep '^color '
color                        on
```

## Available Colors

Taskwarrior has a 'color' command that will show all the colors it is capable of displaying. Try this:

```
$ task color
```

The output cannot be replicated here in a man page, but you should see a set of color samples. How many you see depends on your terminal program's ability to render them.

You should at least see the Basic colors and Effects - if you do, then you have 16-color support. If your terminal supports 256 colors, you'll know it!

## 16-Color Support

The basic color support is provided through named colors:

- `black`, `red`, `blue`, `green`, `magenta`, `cyan`, `yellow`, `white`

Foreground color (for text) is simply specified as one of the above colors, or not specified at all to use the default terminal text color.

Background color is specified by using the word 'on', and one of the above colors. Some examples:

- `green` - green text, default background color
- `green on yellow` - green text, yellow background
- `on yellow` - default text color, yellow background

These colors can be modified further, by making the foreground bold, or by making the background bright. Some examples:

- `bold green`
- `bold white on bright red`
- `on bright cyan`

The order of the words is not important, so the following are equivalent:

- `bold green`
- `green bold`

But the 'on' is important - colors before the 'on' are foreground, and colors after 'on' are background.

There is an additional 'underline' attribute that may be used:

- `underline bold red on black`

And an 'inverse' attribute:

- `inverse red`

Taskwarrior has a command that helps you visualize these color combinations. Try this:

```
$ task color underline bold red on black
```

You can use this command to see how the various color combinations work. You will also see some sample colors displayed, like the ones above, in addition to the sample requested.

Some combinations look very nice, some look terrible. Different terminal programs do implement slightly different versions of 'red', for example, so you may see some unexpected variation across machines. The brightness of your display is also a factor.

## 256-Color Support

Using 256 colors follows the same form, but the names are different, and some colors can be referenced in different ways. First there is by color ordinal, which is like this:

- `color0`
- `color1`
- `color2`
- ...
- `color255`

This gives you access to all 256 colors, but doesn't help you much. This range is a combination of:
- 8 basic colors (color0 - color7)
- 8 brighter variations (color8 - color15)
- A block of 216 colors (color16 - color231)
- A block of 24 gray colors (color232 - color255)

The large block of 216 colors (6x6x6 = 216) represents a color cube, which can be addressed via RGB values from 0 to 5 for each component color. A value of 0 means none of this component color, and a value of 5 means the most intense component color. For example:

- A bright red is specified as: `rgb500`
- A darker red would be: `rgb300`

The three digits represent the three component values, so in this example the 5, 0 and 0 represent red=5, green=0, blue=0. Combining intense red with no green and no blue yields red. Similarly:

- Blue: `rgb005`
- Green: `rgb050`
- Bright yellow (mix of bright red and bright green): `rgb550`
- Soft pink: `rgb515`

You can verify these by running:

```
$ task color black on rgb515
```

The block of 24 gray colors can also be accessed as `gray0` - `gray23`, in a continuous ramp from black to white.

## Mixing 16- and 256-Colors

If you specify 16-colors and view on a 256-color terminal, no problem. If you try the reverse, specifying 256-colors and viewing on a 16-color terminal, you will be disappointed.

There is some limited color mapping. For example, if you specify:

- `red on gray3`

Taskwarrior will map red to color1 and proceed. Note that red and color1 are not quite the same tone.

Note also that there is no bold or bright attributes when dealing with 256 colors, but there is still underline available.

## Legend

Taskwarrior will show examples of all defined colors used in your .taskrc or theme if you run:

```
$ task color legend
```

This gives you an example of each of the colors, so you can see the effect, without necessarily creating a set of tasks that meet each of the rule criteria.

## Rules

Taskwarrior supports colorization rules. These are configuration values that specify a color and the conditions under which that color is used. 

Example:
```
$ task add project:Home priority:H pay the bills               (1)
$ task add project:Home            clean the rug               (2)
$ task add project:Garden          clean out the garage        (3)
```

Add a color rule for Home project:
```
$ task config color.project.Home 'on blue'
```

Add a color rule for cleaning tasks:
```
$ task config color.keyword.clean 'bold yellow'
```

Color rules can be applied by:
- Project
- Description keyword
- Priority
- Active status
- Due or overdue status
- Tagged tasks
- Specific tags
- Recurring tasks

The precedence for color rules is determined by `rule.precedence.color`, which by default contains:
```
deleted,completed,active,keyword.,tag.,project.,overdue,scheduled,due.today,due,blocked,blocking,recurring,tagged,uda.
```

There are also specific rules for missing data:
- `color.project.none`
- `color.tag.none`
- `color.uda.priority.none`

## Themes

Taskwarrior supports themes through file inclusion in .taskrc. To add a theme:

```
include dark-256.theme
```

Available themes include:
- `dark-16.theme`
- `dark-256.theme`
- `dark-blue-256.theme`
- `dark-gray-256.theme`
- `dark-green-256.theme`
- `dark-red-256.theme`
- `dark-violets-256.theme`
- `dark-yellow-green.theme`
- `light-16.theme`
- `light-256.theme`
- `solarized-dark-256.theme`
- `solarized-light-256.theme`
- `dark-default-16.theme`
- `dark-gray-blue-256.theme`
- `no-color.theme`

You can preview a theme's colors with:

```
$ task color legend
```

## Credits & Copyrights

Copyright (C) 2006 - 2021 T. Babej, P. Beckingham, F. Hernandez.

Taskwarrior is distributed under the MIT license. See https://www.opensource.org/licenses/mit-license.php for more information.

## See Also

- `task(1)`
- `taskrc(5)`
- `task-sync(5)`

### More Information

- Official site: https://taskwarrior.org
- Official code repository: https://github.com/GothenburgBitFactory/taskwarrior
- Contact: support@GothenburgBitFactory.org

## Reporting Bugs

Bugs in Taskwarrior may be reported to the issue-tracker at https://github.com/GothenburgBitFactory/taskwarrior/issues
