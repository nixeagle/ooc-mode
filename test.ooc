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
foo := 12


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

Baz: class extends Foo {
    init: func ~a (a: Int) {
        "baz init" println()
    }

    doSomething: func {
        "Baz doSomething" println()
    }
}

main: func {
    f := Baz new()      // => "foo init"
    f doSomething()     // => "Foo doSomething"
}

