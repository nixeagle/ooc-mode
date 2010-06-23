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


import structs/[HashMap, Stack, ArrayList], text/StringTokenizer
             import Word, Data // should not be indented