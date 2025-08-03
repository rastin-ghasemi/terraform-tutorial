## Type Constraints in Terraform (Simplified Explanation)
Type constraints in Terraform define what kind of data a variable or output can hold. They enforce rules like:

- "This must be a string."

- "This must be a list of numbers."

- "This must be a map with specific keys."

## Why Use Type Constraints?
1. **Prevent Errors**

- Stops invalid inputs (e.g., passing a string where a number is expected).

2. **Self-Documenting Code**

- Makes it clear what values are allowed.

3. **Better IDE Support**

- Tools like VSCode can autocomplete and validate types.

## Primitive Types
A primitive type is a simple type that isn't made from any other types. All primitive types in Terraform are represented by a type keyword. The available primitive types are:

1. string: a sequence of Unicode characters representing some text, such as "hello".
2. number: a numeric value. The number type can represent both whole numbers like 15 and fractional values such as 6.283185.
3. bool: either true or false. bool values can be used in conditional logic.

## Conversion of Primitive Types
The Terraform language will automatically convert number and bool values to string values when needed, and vice-versa as long as the string contains a valid representation of a number or boolean value.

- true converts to "true", and vice-versa
- false converts to "false", and vice-versa
- 15 converts to "15", and vice-versa

## Complex Types
A complex type is a type that groups multiple values into a single value. Complex types are represented by type constructors, but several of them also have shorthand keyword versions.

There are two categories of complex types: collection types (for grouping similar values), and structural types (for grouping potentially dissimilar values).

## Collection Types
A collection type allows multiple values of one other type to be grouped together as a single value. The type of value within a collection is called its element type. All collection types must have an element type, which is provided as the argument to their constructor.

For example, the type list(string) means "list of strings", which is a different type than list(number), a list of numbers. All elements of a collection must always be of the same type.

The three kinds of collection type in the Terraform language are:

- list(...): a sequence of values identified by consecutive whole numbers starting with zero.

The keyword list is a shorthand for list(any), which accepts any element type as long as every element is the same type. This is for compatibility with older configurations; for new code, we recommend using the full form.

- map(...): a collection of values where each is identified by a string label.

The keyword map is a shorthand for map(any), which accepts any element type as long as every element is the same type. This is for compatibility with older configurations; for new code, we recommend using the full form.

You can use the following characters to define maps:

- `{}` 
- `:` 
- `=` 

For example, { "foo": "bar", "bar": "baz" } and { foo = "bar", bar = "baz" } define the same map. You must place map keys in quotation marks when a key starts with a number, contains spaces, or contains special characters. Otherwise, you can omit them. You must place commas between keys-value pairs in single-line maps. You can place key-value pairs in multi-line maps on new lines.

Note: Although colons are valid delimiters between keys and values, terraform fmt ignores them. In contrast, terraform fmt attempts to vertically align equals signs.

set(...): a collection of unique values that do not have any secondary identifiers or ordering.

## Structural Types
A structural type allows multiple values of several distinct types to be grouped together as a single value. Structural types require a schema as an argument, to specify which types are allowed for which elements.

The two kinds of structural type in the Terraform language are:

- object(...): a collection of named attributes that each have their own type.

The schema for object types is { <KEY> = <TYPE>, <KEY> = <TYPE>, ... } — a pair of curly braces containing a comma-separated series of <KEY> = <TYPE> pairs. Values that match the object type must contain all of the specified keys, and the value for each key must match its specified type. (Values with additional keys can still match an object type, but the extra attributes are discarded during type conversion.)

- tuple(...): a sequence of elements identified by consecutive whole numbers starting with zero, where each element has its own type.

The schema for tuple types is [<TYPE>, <TYPE>, ...] — a pair of square brackets containing a comma-separated series of types. Values that match the tuple type must have exactly the same number of elements (no more and no fewer), and the value in each position must match the specified type for that position.

For example: an object type of object({ name=string, age=number }) would match a value like the following:

{
  name = "John"
  age  = 52
}

Also, an object type of object({ id=string, cidr_block=string }) would match the object produced by a reference to an aws_vpc resource, like aws_vpc.example_vpc; although the resource has additional attributes, they would be discarded during type conversion.

Finally, a tuple type of tuple([string, number, bool]) would match a value like the following:

["a", 15, true]

