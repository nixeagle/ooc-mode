class DB extends PDO { }
// check for an alphanumeric character
isAlphaNumeric: func -> Bool {
    isAlpha() || isDigit()
}


// check for an alphabetic character
isAlpha: func -> Bool {
    isLower() || isUpper()
}

|foo,bar,baz|

{
    match scancode {
        // Shift key press
        case 0x2A =>
            shift = true

            // Shift key release
        case 0xAA =>
            shift = false

            // Any other scan code
        case =>
            chr := (shift ? uppercase : lowercase)[scancode] as Char
            Bochs debug("Char: %c" format(chr))
            chr print()
    }
}

max: Int
max, foo: aaaaa() aa
// C does work
// The foo: is the same as main here right?
int main () {

}

int foo;

// ooc names
a:
foo:
foo!:
foo?:
Af:

// ooc invalid names: (should break)
fo!o:
0a:
(a):


// Sample working ooc snippet
foo: func (String) -> /* foo */ Int {}

foo: Int

// assignment
foo := 12;




// more ooc testing
Foo: class {
    init: func { init(1) }

    init: func ~a (a: Int) {
        "foo init" println()
    }

    doSomething: func {
        "Foo doSomething" println()
    }
}

abc: func a (c: a) {
  return 1 + 2;
}

a
b
int foo () {
  a

  {

  }
}
c
d
e;

Baz: class extends Foo {
    init: func ~a (a: Int) {
        "baz init" println()
        a
        a
        a
    }
    func ~a (a: Int) {
      a
      a
      a

      a
      aaa
      a;


    }

    doSomething: func {
        "Baz doSomething" println()
    }
  }
}

main: func {
  f := Baz new()      // => "foo init"

  // C mode issue
  f doSomething()     // => "Foo doSomething"
      }

abcdefghi:
{
}
Display: class {
    VIDEO_MEMORY := static 0xb8000 as UInt16*

    INDEX_PORT := static 0x3d4
    DATA_PORT  := static 0x3d5

    CURSOR_LOW_PORT  := static 0xE
    CURSOR_HIGH_PORT := static 0xF

    attr: static UInt8
    foreground: static Color
    background: static Color
    cursor_x: static Int
    cursor_y: static Int

    setup: static func {
        // default to light grey on black like the BIOS
        setAttr(Color lightGrey, Color black)
        clearScreen()
    }

    setAttr: static func (fg, bg: Color) {
        foreground = fg
        background = bg
        attr = (fg & 0xf) | bg << 4
    }
}


import structs/[HashMap, Stack, ArrayList], text/StringTokenizer
import Word

DEBUG := false

Runtime: class {
    datastack := Stack<Int> new() // TODO Don't use Int, of course
    vocab := HashMap<String, Word> new()

    init: func {
        // ( x y -- z )
        defineWord("+", |stack|
            stack push(stack pop() + stack pop())
        )

        // ( x y -- z )
        defineWord("-", |stack|
            y := stack pop()
            x := stack pop()
            stack push(x - y)
        )

        // ( x y -- z )
        defineWord("*", |stack|
            stack push(stack pop() * stack pop())
        )

        // ( x y -- z )
        defineWord("/", |stack, a|
            y := stack pop()
            x := stack pop()
            stack push(x / y)
        )

        // ( x -- )
        defineWord(".", |stack|
            stack pop() toString() println()
        )

        // ( x y -- y x )
        defineWord("swap", |stack|
            y := stack pop()
            x := stack pop()
            stack push(y)
            stack push(x)
        )

        // ( x -- x x )
        defineWord("dup", |stack|
            stack push(stack peek())
        )
    }

    defineWord: func (name: String, body: Func (Stack<Int>)) {
        vocab[name] = Word new(name, body)
    }

    /* evaluate: func (code: String) { */
    /*     tree := parse(code) */
    /* } */

    evaluate: func (code: String) /* -> ArrayList<Object> */ {
        tokenizer := StringTokenizer new(code, ' ')
        /* tree := ArrayList<Object> new() */

        /* while(tokenizer hasNext()) { */
        /*     token := tokenizer next() */
        /*     word := vocab[token] */
        /*     if(word) { */
        /*     } */
        /* } */

        for(token in tokenizer) {
            word := vocab[token]
            if(word) {
                if(DEBUG) ("Calling: " + token) println()
                fn := word body
                fn(datastack)
            } else if(isNumber(token)) {
                datastack push(toNumber(token))
            } else {
                Exception new("No word named \"" + token + "\" found in vocabulary.") throw()
            }
            if(DEBUG) stackDebug(datastack)
        }
    }

    isNumber: func (str: String) -> Bool {
        for(chr in str) {
            if(!chr isDigit())
                return false
        }
        true
    }

    toNumber: func (str: String) -> Int {
        str toInt()
    }

    stackDebug: static func (stack: Stack<Int>) {
        inspected := ArrayList<String> new()
        for(n in stack) {
            inspected add(n toString())
        }
        ("Datastack: [" + inspected join(", ") + "]") println()
    }
}


defineWord("dup", func (stack: func (Stack<Int>)) {
        stack push(stack peek())
    })

asdf(foo(bar(|baz|
            code
        )), |something|
    code
)


// should indent only one level for each |....| argument like this:
defineWord("word-test", |stack|
    stack push(Word new("test", |stack_|
        "this is a test" println()
    ))
)
// we do
defineWord("word-test", |stack|
    stack push(Word new("test", |stack_|
            "this is a test" println()
        ))
)

import IRQ, Ports, Bochs, Keys

Scancode: cover {
    ESC        := static 0x01
    ENTER      := static 0x1c
    LCTRL      := static 0x1d
    LSHIFT     := static 0x2a
    RSHIFT     := static 0x36
    LALT       := static 0x38
    CAPSLOCK   := static 0x3a
    NUMLOCK    := static 0x45
    SCROLLLOCK := static 0x46
}

Keyboard: cover {
    lowercase: static Char[128] = [
        0, 27, '1', '2', '3', '4', '5', '6', '7', '8', /* 9 */
        '9', '0', '-', '=', 0x08, /* Backspace */
        '\t', /* Tab */
        'q', 'w', 'e', 'r', /* 19 */
        't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n', /* Enter key */
        0, /* 29 - Control */
        'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';', /* 39 */
        '\'', '`', 0, /* Left shift */
        '\\', 'z', 'x', 'c', 'v', 'b', 'n', /* 49 */
        'm', ',', '.', '/', 0, /* Right shift */
        '*',
        0, /* Alt */
        ' ', /* Space bar */
        0, /* Caps lock */
        0, /* 59 - F1 key ... > */
        0, 0, 0, 0, 0, 0, 0, 0,
        0, /* < ... F10 */
        0, /* 69 - Num lock*/
        0, /* Scroll Lock */
        0, /* Home key */
        0, /* Up Arrow */
        0, /* Page Up */
        '-',
        0, /* Left Arrow */
        0,
        0, /* Right Arrow */
        '+',
        0, /* 79 - End key*/
        0, /* Down Arrow */
        0, /* Page Down */
        0, /* Insert Key */
        0, /* Delete Key */
        0, 0, 0,
        0, /* F11 Key */
        0, /* F12 Key */
        0 /* All other keys are undefined */
    ]

    uppercase: static Char[128] = [
        0, 27, '!', '@', '#', '$', '%', '^', '&', '*', /* 9 */
        '(', ')', '_', '+', 0x08, /* Backspace */
        '\t', /* Tab */
        'Q', 'W', 'E', 'R', /* 19 */
        'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n', /* Enter key */
        0, /* 29 - Control */
        'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':', /* 39 */
        '"', '~', 0, /* Left shift */
        '|', 'Z', 'X', 'C', 'V', 'B', 'N', /* 49 */
        'M', '<', '>', '?', 0, /* Right shift */
        '*',
        0, /* Alt */
        ' ', /* Space bar */
        0, /* Caps lock */
        0, /* 59 - F1 key ... > */
        0, 0, 0, 0, 0, 0, 0, 0,
        0, /* < ... F10 */
        0, /* 69 - Num lock*/
        0, /* Scroll Lock */
        0, /* Home key */
        0, /* Up Arrow */
        0, /* Page Up */
        '-',
        0, /* Left Arrow */
        0,
        0, /* Right Arrow */
        '+',
        0, /* 79 - End key*/
        0, /* Down Arrow */
        0, /* Page Down */
        0, /* Insert Key */
        0, /* Delete Key */
        0, 0, 0,
        0, /* F11 Key */
        0, /* F12 Key */
        0 /* All other keys are undefined */
    ]

    ESCAPE_CODE := static const 0xE0

    // true if this key is being held down
    shift     := static false
    alt       := static false
    ctrl      := static false

    // true if this key is enabled
    capslock  := static false
    numlock   := static false
    scrolllock := static false

    // true if the previous scancode was an escape code
    escaped   := static false

    flushBuffer: static func {
        while(Ports inByte(0x64) bitSet?(0)) {
            Ports inByte(0x60)
        }
    }

    updateLights: static func {
        status: UInt8 = 0

        if(scrolllock)
            status |= 1
        if(numlock)
            status |= 2
        if(capslock)
            status |= 4

        // Wait for the keyboard to process our previous input if the
        // input buffer is full.
        while(Ports inByte(0x64) bitSet?(1)) {}
        Ports outByte(0x60, 0xED)
        while(Ports inByte(0x64) bitSet?(1)) {}
        Ports outByte(0x60, status)
    }

    setup: static func {
        numlock = true

        updateLights()
        flushBuffer()

        // The keyboard interrupt handler.
        IRQ handlerInstall(1, |regs|
            scancode := Ports inByte(0x60)
            Bochs debug("Scancode: %i" format(scancode))

            if(scancode == ESCAPE_CODE) {
                escaped = true
            } else if(scancode bitSet?(7)) {
                // This scancode defines that a key was just released (key-up).
                match(scancode bitClear(7)) {
                    // Shift key release
                    case Scancode LSHIFT =>
                        shift = false
                }
            } else {
                match scancode {
                    // Shift key press
                    case Scancode LSHIFT =>
                        shift = true

                    // Any other scan code
                    case =>
                        chr := (shift ? uppercase : lowercase)[scancode] as Char
                        Bochs debug("Char: %c" format(chr))
                        chr print()
                }
            }
            }
    }
}
}
}


{
    {
        {
            {
            }
        }
    }
}


case A, asfas


