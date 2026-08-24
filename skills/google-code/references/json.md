# JSON

Condensed from the Google JSON style guide,
`https://google.github.io/styleguide/jsoncstyleguide.xml`.

Scope caveat: this guide targets the JSON that a web API sends and receives. It's the oldest
guide in the set, and its reserved-property conventions describe Google's own API shape. Apply
the naming and value rules broadly; apply the reserved-property section only when you're
designing an API that wants to look like Google's. For a configuration file such as
`settings.json` or `tsconfig.json`, the tool's own schema and the repository's convention win.

## Core rules

- JSON has no comment syntax. Don't add one. Put explanation in documentation, or in a
  descriptive property that's part of the schema.
- Quote every string with double quotes. Single quotes aren't JSON.
- Make the root of a document an object, not an array, so you can add a sibling property later
  without breaking every consumer.
- A property value must be a string, number, boolean, object, array, or null. Nothing else is
  JSON.

## Property names

- Use camel-cased ASCII strings. The first character must be a letter, an underscore, or a
  dollar sign; later characters may also be digits. The rules mirror JavaScript identifier
  naming, so a client can reach the property with dot notation.
- The naming rules don't apply when the object is used as a map. Map keys may hold any Unicode
  character, since clients read them with bracket notation.
- Don't use a reserved JavaScript keyword as a property name.
- Name an array property in the plural and every other property in the singular: `items`,
  `totalItems`, `kind`.
- Keep names consistent across the whole API. The same concept takes the same name everywhere.
- Choose a name that describes the value's meaning, not its type or its storage.

## Property values

- Represent an enumerated value as a string, not as an integer. A string survives reordering and
  reads correctly in a log.
- Consider omitting a property whose value is null or empty, unless the absence and the empty
  value mean different things to the consumer. Say which one you chose in the API documentation.
- Format a date or timestamp per RFC 3339: `"2007-11-06T16:34:41.000Z"`. Use UTC and keep the
  offset explicit.
- Format a duration per ISO 8601: `"P3Y6M4DT12H30M5S"`.
- Format a latitude and longitude pair per ISO 6709 as a single string:
  `"37.422131,-122.084801"`.

## Structure

- Prefer a flat structure. Add a level of nesting only when it groups values that genuinely
  travel together.
- Don't repeat the parent's name in a child's: inside `author`, the property is `name`, not
  `authorName`.
- Keep the shape stable across responses. A property that sometimes holds an object and
  sometimes a string forces every consumer to branch.

## Reserved property names for a Google-style API

Use these names only with these meanings, and don't reuse them for anything else.

**Top level**

`apiVersion`, `context`, `id`, `method`, `params`, `data`, `error`.

A response carries either `data` or `error`, never both. If both appear, `error` wins.

**Inside `data`**

`kind` (what the object is), `fields`, `id`, `lang`, `updated`, `deleted`, `items` (the array of
results), and the paging properties `currentItemCount`, `itemsPerPage`, `startIndex`,
`totalItems`, `pageIndex`, `totalPages`, `pageLinkTemplate`, `next`, `nextLink`, `previous`,
`previousLink`, `self`, `selfLink`.

**Inside `error`**

`code` (an integer status), `message` (a human-readable summary), and `errors`, an array whose
entries carry `domain`, `reason`, `message`, `location`, `locationType`, `extendedHelp`, and
`sendReport`.

## Security notes

These aren't in the upstream guide; they apply to the JSON you produce in this environment.

- Never place a secret, a credential, a token, or a cloud account or project identifier in a
  JSON payload you send outside the local machine.
- Return an error `message` that helps the caller without disclosing internal paths, stack
  frames, or query text. Put the detail in the server log, keyed by a correlation ID you also
  return.
- Validate JSON against a schema at every trust boundary before you act on it.
