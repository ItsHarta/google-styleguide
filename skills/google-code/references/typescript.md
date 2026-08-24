# TypeScript and JavaScript

Condensed from the Google TypeScript style guide,
`https://google.github.io/styleguide/tsguide.html`, and the Google JavaScript style guide,
`https://google.github.io/styleguide/jsguide.html`. Prefer TypeScript for new code.

## Formatting

- The TypeScript guide deliberately carries no formatting section: it states that examples are
  non-normative and that "optional formatting choices made in examples must not be enforced as
  rules". Formatting comes from the JavaScript guide and from whatever formatter your project
  runs, such as `clang-format` or `gts`.
- Indent two spaces per block (JavaScript guide 4.2), and hold an 80-column limit.
- Encode source files as UTF-8, and use the ASCII space as the only whitespace character outside
  a line terminator.
- Terminate every statement with a semicolon. Never rely on automatic semicolon insertion.
- Brace every control structure, including a single-statement `if`.
- Use single quotes for a string literal. Use a template literal for interpolation, never
  concatenation, and never a backslash line continuation inside a string.

## File structure

Order a file as: license or copyright header, `@fileoverview` JSDoc, imports, then
implementation. Separate each section with a blank line.

- Use ES module `import` and `export`. Don't use `namespace`, and don't build a container class
  of statics to fake one — a module is the namespace.
- Export by name only. Don't use a default export.
- Use a named import for a few frequently-used symbols, and a module namespace import
  (`import * as foo from './foo';`) when you pull in many.
- Don't export a mutable binding. Export a function that returns the value instead.
- Don't use `require` or a dynamic import path built from a variable.
- Use `import type {Foo} from './foo';` when you use the symbol only as a type, and a regular
  import for values. The inline form `import {type Foo, Bar} from './foo';` also works.

## Types

- Rely on inference for a trivially inferred type. Write `const x = 5;`, not
  `const x: number = 5;`. Annotate where the type isn't obvious from the initializer, and always
  annotate an exported function's signature.
- Avoid `any`. Reach for a specific type, a generic, or `unknown` first. If `any` is genuinely
  the answer, write a comment saying why.
- Never use the wrapper object types `String`, `Boolean`, `Number`, or `Object`, and avoid the
  empty type `{}`.
- Prefer an `interface` to a type alias for an object type. Use a type alias for a union, a
  tuple, or a mapped type.
- Mark an optional property with `?` rather than a `| undefined` union.
- Use the non-null assertion `!` sparingly, and only where you can explain why the value can't
  be null. Prefer a check that narrows the type.
- Don't prefix an interface with `I`.
- Use a plain `enum`, not a `const enum`.
- Write an array type as `T[]` or `readonly T[]`, including multi-dimensional simple types
  (`T[][]`). Fall back to `Array<T>` only when the element type is complex enough that the
  sugar hurts.
- The guide states no preference between `undefined` and `null` for absence. Match the API you
  sit next to — many JavaScript APIs return `undefined`, many DOM and Google APIs return `null`.
- Prefer structural types. Don't add a nominal brand unless you have a concrete reason.

## Variables and functions

- Declare with `const` by default and `let` when you reassign. Never use `var`.
- Declare one variable per statement.
- Use an arrow function for a callback, so `this` binds lexically. Don't use a function
  expression where `this` matters.
- Give a function a single clear purpose and a return type the caller can rely on.
- Don't reassign a parameter.

## Naming

| Kind | Form |
|---|---|
| Class, interface, type, enum, decorator, type parameter | `UpperCamelCase` |
| Variable, parameter, function, method, property, module alias | `lowerCamelCase` |
| Global constant value, enum value | `CONSTANT_CASE` |

- Treat an abbreviation as a word: `loadHttpUrl`, not `loadHTTPURL`. An established prefix such
  as `XMLHttpRequest` keeps its own casing.
- Don't mark a private member with a leading or trailing underscore. Use the `private` keyword.
- Name for what the value means, not for its type. Don't encode the type in the name.
- Use a descriptive name over a short one, except for a short-lived loop variable.

## Classes

- Use TypeScript's `private` and `protected` visibility rather than `#private` fields.
- Symbols are public by default. Never write `public` except on a non-readonly public parameter
  property in a constructor.
- Use a constructor parameter property to assign a field directly, rather than an explicit
  declaration plus assignment.
- Write a getter or setter only when it's cheap and side-effect free. Anything expensive is a
  method.
- Don't define a class whose members are all static. Export functions from a module.

## Comparisons and control flow

- Use `===` and `!==`. The one exception is `== null` and `!= null`, which check for null and
  undefined together.
- Prefer `for (… of someArr)` to iterate an array. `Array.prototype.forEach` and a counting
  `for` loop are also allowed.
- Never use an unfiltered `for (… in …)`: it includes enumerable properties from the prototype
  chain. Either filter with `hasOwnProperty`, or iterate `Object.keys(…)` instead.
- Give every `switch` a `default` case, and end every non-empty case with `break`, `return`, or
  `throw`.
- Throw an `Error` instance, never a string or a plain object, so the stack trace survives.
- Handle or rethrow a caught error. An empty `catch` block needs a comment explaining why
  swallowing is correct — usually it isn't.

## Comments and prohibited constructs

- Use `/** … */` JSDoc for documentation and `//` for implementation notes.
- Document every exported symbol. Don't repeat type information in JSDoc — the annotations
  already carry it, so drop `@param {string}` and keep the prose.
- Never use `eval` or the `Function` constructor on a string. Both execute arbitrary text.
- Don't ship a `debugger` statement.
- Use `@ts-ignore` and `@ts-expect-error` only with a comment naming the reason, and prefer
  fixing the type.
- Don't modify a built-in prototype.
- Mark an obsolete symbol `@deprecated` with a pointer to the replacement, rather than deleting
  it out from under callers.
- Generated code is mostly exempt from the guide. Don't hand-edit it to conform.
- Consistency within a project outranks a preference the guide leaves open.
