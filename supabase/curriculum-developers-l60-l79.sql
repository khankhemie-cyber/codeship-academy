-- =============================================================================
-- CODEship Academy — Developers Lessons l60–l79
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l60', 'Python Recursion', 'developers', 'Python', 'en', 'intermediate', 35, 150, 60, '## Python Recursion

So far, every time you have repeated an action in Python, you have used a loop. Today you will learn a second way to repeat actions: **recursion**. Recursion is when a function calls *itself* to solve a smaller version of the same problem.

It sounds strange at first — a function calling itself? — but recursion is one of the most powerful ideas in computer science. Many problems (especially ones involving trees, nested data, or "do this, then do a smaller version of this") are much easier to write recursively than with loops.

### The Two Parts of Every Recursive Function

Every recursive function needs exactly two parts:

1. **Base case** — the condition where the function stops calling itself and just returns an answer directly.
2. **Recursive case** — where the function calls itself with a smaller or simpler version of the problem.

If you forget the base case, your function will call itself forever (or until Python runs out of memory) and crash with a `RecursionError`.

### Example 1: Countdown

```python
def countdown(n):
    if n <= 0:          # base case
        print("Liftoff!")
        return
    print(n)
    countdown(n - 1)    # recursive case

countdown(5)
# 5
# 4
# 3
# 2
# 1
# Liftoff!
```

Each call to `countdown` makes the problem smaller (`n` gets closer to 0) until it hits the base case and stops.

### Example 2: Factorial

The factorial of a number `n` (written `n!`) is `n * (n-1) * (n-2) * ... * 1`. It has a natural recursive definition:

- `0! = 1` (base case)
- `n! = n * (n-1)!` (recursive case)

```python
def factorial(n):
    if n == 0:
        return 1
    return n * factorial(n - 1)

print(factorial(5))   # 5 * 4 * 3 * 2 * 1 = 120
```

Let''s trace through `factorial(3)` step by step:

```
factorial(3) = 3 * factorial(2)
factorial(2) = 2 * factorial(1)
factorial(1) = 1 * factorial(0)
factorial(0) = 1                 <- base case hit!

Now it unwinds:
factorial(1) = 1 * 1 = 1
factorial(2) = 2 * 1 = 2
factorial(3) = 3 * 2 = 6
```

### Example 3: Sum of a List

```python
def sum_list(numbers):
    if len(numbers) == 0:        # base case: empty list sums to 0
        return 0
    return numbers[0] + sum_list(numbers[1:])

print(sum_list([1, 2, 3, 4]))    # 10
```

Each call removes the first item and asks "what is the sum of everything else?" — a smaller version of the same problem.

### Example 4: Counting Down a Nested List (Recursion Shines Here)

Recursion is especially useful for nested structures, which are awkward with loops alone:

```python
def count_items(data):
    total = 0
    for item in data:
        if isinstance(item, list):
            total += count_items(item)   # recurse into the sub-list
        else:
            total += 1
    return total

nested = [1, [2, 3, [4, 5]], 6]
print(count_items(nested))   # 6
```

### Recursion vs. Loops

Anything you can write recursively, you can also write with a loop — and vice versa. Recursion is usually chosen when:

- The problem is naturally defined in terms of smaller versions of itself (factorials, Fibonacci, tree structures, nested folders).
- It makes the code shorter and easier to read than the loop version.

Loops are usually chosen when:

- The repetition is simple and flat (like counting from 1 to 100).
- Performance matters a lot — recursion has overhead because Python has to remember every call.

### A Common Mistake

```python
def broken_countdown(n):
    print(n)
    broken_countdown(n - 1)   # no base case!

broken_countdown(5)   # crashes with RecursionError
```

Always ask yourself: "What is the smallest version of this problem, and what should happen then?" That is your base case.

### Key Takeaways

- Recursion is when a function calls itself to solve a smaller version of a problem.
- Every recursive function needs a **base case** (where it stops) and a **recursive case** (where it calls itself with a smaller problem).
- Forgetting the base case causes infinite recursion and a `RecursionError`.
- Recursion is great for naturally nested or self-similar problems, like factorials or nested lists.
- Anything recursive can also be written as a loop — choose whichever is clearer for the problem.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l61', 'Python Lambda Functions, map() and filter()', 'developers', 'Python', 'en', 'intermediate', 35, 150, 61, '## Lambda Functions, map() and filter()

You already know how to define functions with `def`. Today you will learn a shorter way to write small, throwaway functions called **lambda functions**, and two powerful tools that often use them: `map()` and `filter()`.

### What Is a Lambda Function?

A lambda function is a tiny, unnamed function written in a single line. Instead of:

```python
def square(x):
    return x ** 2
```

you can write:

```python
square = lambda x: x ** 2
print(square(5))   # 25
```

The syntax is: `lambda parameters: expression`. There is no `return` keyword — the result of the expression is automatically returned.

Lambdas can take multiple parameters too:

```python
add = lambda a, b: a + b
print(add(3, 4))   # 7
```

Lambdas are best used for small, simple operations — not for anything that needs multiple lines or complex logic. If your function needs more than one expression, use a regular `def` function instead.

### map(): Apply a Function to Every Item

`map(function, iterable)` applies a function to every item in a list (or other iterable) and gives back a new "map object" (which you usually convert to a list).

```python
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x ** 2, numbers))
print(squared)   # [1, 4, 9, 16, 25]
```

This is equivalent to the loop:

```python
squared = []
for x in numbers:
    squared.append(x ** 2)
```

...but `map()` with a lambda does it in one line.

You can also use `map()` with a named function:

```python
def celsius_to_fahrenheit(c):
    return c * 9 / 5 + 32

temps_c = [0, 20, 37, 100]
temps_f = list(map(celsius_to_fahrenheit, temps_c))
print(temps_f)   # [32.0, 68.0, 98.6, 212.0]
```

### filter(): Keep Only Items That Pass a Test

`filter(function, iterable)` keeps only the items where the function returns `True`.

```python
numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
evens = list(filter(lambda x: x % 2 == 0, numbers))
print(evens)   # [2, 4, 6, 8, 10]
```

This is equivalent to:

```python
evens = []
for x in numbers:
    if x % 2 == 0:
        evens.append(x)
```

Another example — filtering words by length:

```python
words = ["cat", "elephant", "dog", "hippopotamus", "ox"]
long_words = list(filter(lambda w: len(w) > 3, words))
print(long_words)   # ["elephant", "hippopotamus"]
```

### Combining map() and filter()

You can chain them together. For example, square only the even numbers:

```python
numbers = [1, 2, 3, 4, 5, 6]
result = list(map(lambda x: x ** 2, filter(lambda x: x % 2 == 0, numbers)))
print(result)   # [4, 16, 36]
```

### How This Compares to List Comprehensions

You learned list comprehensions in the last lesson — and in Python, they are usually preferred over `map()`/`filter()` because they read more naturally:

```python
numbers = [1, 2, 3, 4, 5, 6]

# map() + filter() version
result = list(map(lambda x: x ** 2, filter(lambda x: x % 2 == 0, numbers)))

# list comprehension version (often considered more "Pythonic")
result = [x ** 2 for x in numbers if x % 2 == 0]

print(result)   # [4, 16, 36] either way
```

It is still important to recognize `map()`, `filter()`, and `lambda` because you will see them often in other people''s code, in documentation, and in job interview questions.

### When to Use a Lambda vs. a Named Function

Use a lambda when:
- The function is simple (one expression).
- You only need it once, often as an argument to another function like `map()`, `filter()`, or `sorted()`.

```python
students = [("Amir", 92), ("Lina", 85), ("Theo", 99)]
students_sorted = sorted(students, key=lambda s: s[1], reverse=True)
print(students_sorted)
# [("Theo", 99), ("Amir", 92), ("Lina", 85)]
```

Use a regular `def` function when:
- The logic is complex or spans multiple lines.
- You will reuse it in many places and want it to have a clear, readable name.

### Key Takeaways

- A lambda function is a small, unnamed, one-line function: `lambda x: x * 2`.
- `map(function, iterable)` applies a function to every item and returns the results.
- `filter(function, iterable)` keeps only the items for which the function returns `True`.
- Both `map()` and `filter()` return special objects — wrap them in `list()` to see or use the results as a list.
- List comprehensions often do the same job more readably, but `map()`/`filter()`/`lambda` appear everywhere in real-world Python code.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l62', 'Python Decorators (Introduction)', 'developers', 'Python', 'en', 'intermediate', 35, 150, 62, '## Python Decorators (Introduction)

You have learned that functions can be passed around like any other value in Python. Today you will use that idea to understand **decorators** — a feature that lets you add extra behavior to a function without changing its code.

Decorators look a little strange the first time you see them, but the idea behind them is simple: a decorator is a function that takes another function as input, wraps it with some extra behavior, and returns a new function.

### Functions Can Be Passed Into Other Functions

Before decorators make sense, remember that in Python, functions are values — you can pass them as arguments, just like a number or a string:

```python
def shout(text):
    return text.upper() + "!"

def greet(func):
    print(func("hello"))

greet(shout)   # HELLO!
```

### Functions Can Return Other Functions

A function can also define and return a brand-new function:

```python
def make_multiplier(n):
    def multiplier(x):
        return x * n
    return multiplier

times3 = make_multiplier(3)
print(times3(10))   # 30
```

This is the key trick decorators rely on: a function that builds and returns another function.

### Building Your First Decorator

A decorator is a function that takes a function, defines a "wrapper" function around it, and returns that wrapper.

```python
def shout_decorator(func):
    def wrapper(text):
        result = func(text)
        return result.upper() + "!"
    return wrapper

def greet(name):
    return f"Hello, {name}"

loud_greet = shout_decorator(greet)
print(loud_greet("Maya"))   # HELLO, MAYA!
```

Here, `shout_decorator` wraps `greet` to make it shout. We did not change `greet` itself at all.

### The @ Syntax

Python gives us a shortcut for applying a decorator: the `@` symbol placed directly above a function definition.

```python
def shout_decorator(func):
    def wrapper(text):
        result = func(text)
        return result.upper() + "!"
    return wrapper

@shout_decorator
def greet(name):
    return f"Hello, {name}"

print(greet("Maya"))   # HELLO, MAYA!
```

`@shout_decorator` above `def greet(name):` is exactly the same as writing `greet = shout_decorator(greet)`. It just looks cleaner.

### A Practical Example: Timing a Function

Decorators are often used for things you want to apply to many functions, like logging or timing:

```python
import time

def time_it(func):
    def wrapper(*args, **kwargs):
        start = time.time()
        result = func(*args, **kwargs)
        end = time.time()
        print(f"{func.__name__} took {end - start:.4f} seconds")
        return result
    return wrapper

@time_it
def slow_square(n):
    total = 0
    for i in range(1_000_000):
        total += i
    return n ** 2

print(slow_square(5))
# slow_square took 0.0XXX seconds
# 25
```

Notice the wrapper uses `*args, **kwargs` so it can decorate *any* function, no matter what arguments it takes.

### Another Example: Checking Permissions

```python
def require_login(func):
    def wrapper(user):
        if not user.get("logged_in"):
            print("Access denied — please log in.")
            return None
        return func(user)
    return wrapper

@require_login
def view_profile(user):
    print(f"Welcome to your profile, {user[''name'']}!")

guest = {"name": "Guest", "logged_in": False}
member = {"name": "Sam", "logged_in": True}

view_profile(guest)    # Access denied — please log in.
view_profile(member)   # Welcome to your profile, Sam!
```

### Why Decorators Matter

Decorators let you add behavior — logging, timing, access checks, caching — to functions without rewriting the function itself. This keeps code clean: the original function stays focused on *its* job, and the decorator handles the *extra* job.

You will see decorators all over real-world Python code, including in popular tools like Flask (`@app.route(...)`), which you will meet later in this course.

### Key Takeaways

- A decorator is a function that takes a function and returns a new, "wrapped" version of it with extra behavior.
- The `@decorator_name` syntax placed above a function definition is shorthand for `func = decorator_name(func)`.
- Wrapper functions commonly use `*args, **kwargs` so they can decorate functions with any number of arguments.
- Decorators are great for adding reusable behavior like timing, logging, or permission checks.
- You will see this same pattern later when working with frameworks like Flask.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l63', 'Python Generators and Iterators', 'developers', 'Python', 'en', 'intermediate', 35, 150, 63, '## Python Generators and Iterators

You have used `for` loops to go through lists, strings, and dictionaries many times. Have you ever wondered how Python actually "knows" how to step through them one item at a time? The answer is **iterators**. Today you will also learn about **generators** — a simple, memory-efficient way to create your own iterators.

### What Is an Iterable vs. an Iterator?

- An **iterable** is anything you can loop over — lists, strings, tuples, dictionaries, sets.
- An **iterator** is the object that actually keeps track of *where you are* in that loop, one step at a time.

Behind the scenes, when you write `for item in my_list:`, Python calls `iter(my_list)` to get an iterator, then repeatedly calls `next()` on it until there is nothing left.

```python
numbers = [10, 20, 30]
iterator = iter(numbers)

print(next(iterator))   # 10
print(next(iterator))   # 20
print(next(iterator))   # 30
print(next(iterator))   # raises StopIteration — nothing left!
```

A `for` loop just does this automatically and stops cleanly when it sees `StopIteration`.

### The Problem With Building Big Lists

Imagine you want the squares of the first 10 million numbers. Building a full list wastes a huge amount of memory:

```python
def square_list(n):
    result = []
    for i in range(n):
        result.append(i ** 2)
    return result

squares = square_list(10_000_000)   # uses a LOT of memory at once
```

### Generators: Producing Values One at a Time

A **generator function** looks like a normal function, but instead of `return`, it uses `yield`. Each time it yields a value, it pauses — remembering exactly where it left off — until the next value is requested.

```python
def square_generator(n):
    for i in range(n):
        yield i ** 2

squares = square_generator(5)
print(squares)          # <generator object ...>

for s in squares:
    print(s)
# 0
# 1
# 4
# 9
# 16
```

Because a generator produces values one at a time instead of building a whole list in memory, it can handle enormous (even infinite!) sequences efficiently.

### Using next() With a Generator

```python
def countdown(n):
    while n > 0:
        yield n
        n -= 1

gen = countdown(3)
print(next(gen))   # 3
print(next(gen))   # 2
print(next(gen))   # 1
print(next(gen))   # raises StopIteration
```

### A Practical Example: Reading Big Files Line by Line

Generators shine when working with large data, like files too big to load all at once:

```python
def read_large_file(file_path):
    with open(file_path, "r") as f:
        for line in f:
            yield line.strip()

# for line in read_large_file("huge_log.txt"):
#     print(line)
```

Only one line is in memory at a time, no matter how big the file is.

### Generator Expressions

Just like list comprehensions, you can write a quick generator using parentheses instead of square brackets:

```python
squares_list = [x ** 2 for x in range(5)]      # a list — all in memory
squares_gen  = (x ** 2 for x in range(5))       # a generator — lazy

print(squares_list)   # [0, 1, 4, 9, 16]
print(squares_gen)    # <generator object ...>
print(list(squares_gen))   # [0, 1, 4, 9, 16] — values produced on demand
```

### An Infinite Generator

Because generators only compute a value when asked, they can represent infinite sequences:

```python
def infinite_counter():
    n = 1
    while True:
        yield n
        n += 1

counter = infinite_counter()
print(next(counter))   # 1
print(next(counter))   # 2
print(next(counter))   # 3
# ... could go on forever, but we only take what we need
```

You would never be able to do this with a regular list — it would try to use infinite memory and crash!

### Generators vs. Lists: When to Use Which

| Use a list when... | Use a generator when... |
|---|---|
| You need to use the data multiple times | You only need to go through it once |
| You need to index into it (`my_list[3]`) | You are processing huge or infinite data |
| The data is small | You want to save memory |

### Key Takeaways

- An iterator is an object that produces items one at a time using `next()`, and raises `StopIteration` when finished.
- A generator function uses `yield` instead of `return`, pausing and resuming instead of computing everything at once.
- Generators are memory-efficient — perfect for huge datasets, big files, or infinite sequences.
- Generator expressions use `(...)` instead of `[...]` to create a lazy version of a list comprehension.
- Once a generator is exhausted, it cannot be restarted — you would need to call the generator function again.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l64', 'Python Regular Expressions (re module)', 'developers', 'Python', 'en', 'intermediate', 35, 150, 64, '## Python Regular Expressions (the re module)

Sometimes you need to search for a *pattern* in text, not just an exact word. Does this string look like an email address? Does it contain a phone number? Does it start with a number? **Regular expressions** (often called "regex") are a mini-language for describing text patterns, and Python''s built-in `re` module lets you use them.

### Getting Started

```python
import re

text = "My favorite number is 42"
match = re.search(r"\d+", text)
print(match.group())   # 42
```

Notice the `r` before the string — that creates a **raw string**, which prevents Python from treating backslashes specially. Always use raw strings for regex patterns.

### Common Pattern Symbols

| Symbol | Meaning |
|---|---|
| `\d` | any digit (0-9) |
| `\w` | any letter, digit, or underscore |
| `\s` | any whitespace (space, tab, newline) |
| `.` | any single character |
| `+` | one or more of the previous thing |
| `*` | zero or more of the previous thing |
| `?` | zero or one of the previous thing |
| `^` | start of the string |
| `$` | end of the string |
| `[]` | a set of characters, e.g. `[aeiou]` |

### re.search(): Find the First Match

```python
import re

text = "Call me at 555-1234 tomorrow"
match = re.search(r"\d{3}-\d{4}", text)
if match:
    print("Found:", match.group())   # Found: 555-1234
else:
    print("No match found")
```

`\d{3}` means "exactly 3 digits", and `\d{4}` means "exactly 4 digits".

### re.findall(): Find Every Match

```python
import re

text = "Apples cost 3 dollars, oranges cost 5 dollars, and grapes cost 12 dollars"
prices = re.findall(r"\d+", text)
print(prices)   # ["3", "5", "12"]
```

Note that `findall` returns strings, so convert them with `int()` if you need to do math:

```python
total = sum(int(p) for p in prices)
print(total)   # 20
```

### re.match() vs re.search()

`re.match()` only checks the *beginning* of the string. `re.search()` checks the *whole* string.

```python
import re

text = "Hello World"
print(re.match(r"World", text))    # None (doesn''t start with "World")
print(re.search(r"World", text))   # finds a match anywhere in the string
```

### re.sub(): Find and Replace

```python
import re

text = "My phone number is 555-1234"
masked = re.sub(r"\d{3}-\d{4}", "XXX-XXXX", text)
print(masked)   # My phone number is XXX-XXXX
```

### Validating an Email Address (Simplified)

```python
import re

def is_valid_email(email):
    pattern = r"^[\w.]+@[\w]+\.[a-z]{2,}$"
    return re.match(pattern, email) is not None

print(is_valid_email("student@school.com"))   # True
print(is_valid_email("not-an-email"))          # False
```

Let''s break this pattern down:
- `^[\w.]+` — start with one or more letters, digits, underscores, or dots (the username)
- `@` — a literal @ symbol
- `[\w]+` — the domain name
- `\.` — a literal dot (escaped, because `.` normally means "any character")
- `[a-z]{2,}$` — 2 or more lowercase letters at the end (like "com" or "org")

Real-world email validation regex is much more complex than this — this is a simplified teaching version!

### Splitting Text With a Pattern

```python
import re

text = "apples, oranges;bananas  grapes"
items = re.split(r"[,;\s]+", text)
print(items)   # ["apples", "oranges", "bananas", "grapes"]
```

This splits on commas, semicolons, or any whitespace, even when they are mixed together.

### A Practical Example: Extracting Hashtags

```python
import re

post = "Loving this #python course! #coding #100DaysOfCode"
hashtags = re.findall(r"#\w+", post)
print(hashtags)   # ["#python", "#coding", "#100DaysOfCode"]
```

### Key Takeaways

- Regular expressions describe *patterns* of text, not just exact matches.
- Always write regex patterns as raw strings: `r"\d+"`.
- `re.search()` finds the first match anywhere; `re.match()` only checks the start of the string; `re.findall()` returns every match as a list.
- `re.sub()` finds a pattern and replaces it with new text.
- Common building blocks: `\d` (digit), `\w` (word character), `\s` (whitespace), `+` (one or more), `*` (zero or more), `{n}` (exactly n times).
- Regex is widely used for validating input (emails, phone numbers) and extracting information from text.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l65', 'Python and JSON / Working with APIs (requests library)', 'developers', 'Python', 'en', 'intermediate', 35, 150, 65, '## Python and JSON / Working with APIs

Websites and apps constantly need to send data to each other — weather apps fetch forecasts, games fetch leaderboards, and shopping sites fetch product prices. Today you will learn **JSON**, the most common format for this data, and how Python can fetch live data from the internet using **APIs**.

### What Is JSON?

JSON (JavaScript Object Notation) is a text format for representing structured data. It looks a lot like a Python dictionary:

```json
{
  "name": "Nova",
  "age": 13,
  "skills": ["Python", "Scratch", "HTML"],
  "is_student": true
}
```

JSON is used almost everywhere on the internet because nearly every programming language can read and write it.

### Converting Between Python and JSON

Python''s built-in `json` module converts between Python objects and JSON text.

```python
import json

# Python dictionary -> JSON string
student = {
    "name": "Nova",
    "age": 13,
    "skills": ["Python", "Scratch", "HTML"]
}

json_string = json.dumps(student)
print(json_string)
print(type(json_string))   # <class ''str''>
```

```python
import json

# JSON string -> Python dictionary
json_text = ''{"name": "Nova", "age": 13, "skills": ["Python", "Scratch"]}''
data = json.loads(json_text)

print(data["name"])     # Nova
print(data["skills"])   # ["Python", "Scratch"]
print(type(data))       # <class ''dict''>
```

Remember: `dumps` = "dump string" (Python → JSON text), `loads` = "load string" (JSON text → Python).

### Reading and Writing JSON Files

```python
import json

student = {"name": "Nova", "age": 13, "skills": ["Python", "HTML"]}

# Write to a file
with open("student.json", "w") as f:
    json.dump(student, f, indent=2)

# Read from a file
with open("student.json", "r") as f:
    loaded_data = json.load(f)

print(loaded_data["name"])   # Nova
```

Notice: `json.dump`/`json.load` (no "s") work directly with files, while `json.dumps`/`json.loads` (with "s") work with strings.

### What Is an API?

An API (Application Programming Interface) is a way for programs to talk to each other over the internet. A **web API** usually lets you request data (like weather, jokes, or trivia questions) by visiting a special URL, and it sends back data — almost always in JSON format.

### Making a Request With the requests Library

Python''s `requests` library makes it easy to fetch data from a web API.

```python
import requests

response = requests.get("https://api.agify.io?name=nova")
print(response.status_code)   # 200 means success
data = response.json()        # automatically parses the JSON response
print(data)
# {"name": "nova", "age": 32, "count": 1234}
```

`response.status_code` tells you whether the request worked. `200` means success; `404` means "not found"; `500` means the server had an error.

### A Practical Example: Fetching a Random Joke

```python
import requests

response = requests.get("https://official-joke-api.appspot.com/random_joke")

if response.status_code == 200:
    joke = response.json()
    print(joke["setup"])
    print(joke["punchline"])
else:
    print("Could not fetch a joke right now.")
```

### Sending Data With a GET Request''s Parameters

Many APIs accept extra options through URL parameters:

```python
import requests

params = {"name": "Maya"}
response = requests.get("https://api.agify.io", params=params)
data = response.json()
print(f"Predicted age for {data[''name'']}: {data[''age'']}")
```

### Handling Errors Gracefully

Network requests can fail — the API might be down, or the internet might be unavailable. Always handle this:

```python
import requests

try:
    response = requests.get("https://api.agify.io?name=nova", timeout=5)
    response.raise_for_status()   # raises an error for bad status codes
    data = response.json()
    print(data)
except requests.exceptions.RequestException as e:
    print(f"Something went wrong: {e}")
```

### Key Takeaways

- JSON is a text format for structured data that looks similar to Python dictionaries and lists.
- `json.dumps()`/`json.loads()` convert between Python objects and JSON strings; `json.dump()`/`json.load()` work directly with files.
- An API lets programs request data from the internet, almost always returning it as JSON.
- The `requests` library''s `requests.get(url)` fetches data, and `.json()` converts the response straight into a Python dictionary or list.
- Always check `response.status_code` or use `raise_for_status()`, and wrap network calls in `try`/`except` since they can fail.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l66', 'Python Working with CSV Files', 'developers', 'Python', 'en', 'intermediate', 35, 150, 66, '## Python Working with CSV Files

Spreadsheets are everywhere — grades, scores, budgets, inventories. The most common plain-text format for spreadsheet-like data is **CSV** (Comma-Separated Values). Today you will learn to read and write CSV files using Python''s built-in `csv` module.

### What Does a CSV File Look Like?

A CSV file is just plain text, where each line is a row, and commas separate the columns:

```
name,age,grade
Amir,13,8
Lina,12,7
Theo,14,8
```

You could technically read this with regular string splitting, but the `csv` module handles tricky edge cases (like commas *inside* a value) correctly, so it is always the better choice.

### Reading a CSV File

```python
import csv

with open("students.csv", "r", newline="") as f:
    reader = csv.reader(f)
    for row in reader:
        print(row)

# [''name'', ''age'', ''grade'']
# [''Amir'', ''13'', ''8'']
# [''Lina'', ''12'', ''7'']
# [''Theo'', ''14'', ''8'']
```

Notice every value comes back as a **string**, even the numbers — you will need to convert them yourself with `int()` or `float()` if you want to do math.

### Skipping the Header Row

The first row is usually a header (column names), not data:

```python
import csv

with open("students.csv", "r", newline="") as f:
    reader = csv.reader(f)
    header = next(reader)     # grabs just the first row
    print("Columns:", header)

    for row in reader:        # the loop now starts from row 2
        print(row)
```

### Reading With DictReader (Much More Convenient)

`csv.DictReader` automatically uses the header row as keys, turning each row into a dictionary:

```python
import csv

with open("students.csv", "r", newline="") as f:
    reader = csv.DictReader(f)
    for row in reader:
        print(row["name"], "is in grade", row["grade"])

# Amir is in grade 8
# Lina is in grade 7
# Theo is in grade 8
```

This is almost always nicer to work with than plain `csv.reader`, because you refer to columns by name instead of by position number.

### Writing a CSV File

```python
import csv

students = [
    ["name", "age", "grade"],
    ["Amir", 13, 8],
    ["Lina", 12, 7],
    ["Theo", 14, 8],
]

with open("output.csv", "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerows(students)
```

`writer.writerow(row)` writes a single row; `writer.writerows(list_of_rows)` writes many rows at once.

### Writing With DictWriter

```python
import csv

students = [
    {"name": "Amir", "age": 13, "grade": 8},
    {"name": "Lina", "age": 12, "grade": 7},
]

with open("output.csv", "w", newline="") as f:
    fieldnames = ["name", "age", "grade"]
    writer = csv.DictWriter(f, fieldnames=fieldnames)
    writer.writeheader()       # writes the column names as the first row
    writer.writerows(students)
```

### A Practical Example: Calculating an Average From a CSV

```python
import csv

total_age = 0
count = 0

with open("students.csv", "r", newline="") as f:
    reader = csv.DictReader(f)
    for row in reader:
        total_age += int(row["age"])
        count += 1

average_age = total_age / count
print(f"Average age: {average_age:.1f}")
```

### A Practical Example: Filtering Rows Into a New CSV

```python
import csv

with open("students.csv", "r", newline="") as infile:
    reader = csv.DictReader(infile)
    grade_8_students = [row for row in reader if row["grade"] == "8"]

with open("grade_8_only.csv", "w", newline="") as outfile:
    writer = csv.DictWriter(outfile, fieldnames=["name", "age", "grade"])
    writer.writeheader()
    writer.writerows(grade_8_students)
```

### A Note on newline=""

You may have noticed `newline=""` in every `open()` call. This is recommended by Python''s own documentation when working with CSV files — it prevents extra blank lines from appearing on some operating systems (especially Windows).

### Key Takeaways

- CSV (Comma-Separated Values) is a simple text format for spreadsheet-like data, with one row per line and commas separating columns.
- `csv.reader` and `csv.writer` work with rows as plain lists of strings.
- `csv.DictReader` and `csv.DictWriter` work with rows as dictionaries, using the header row as keys — usually more convenient.
- All values read from a CSV are strings; convert them with `int()` or `float()` before doing math.
- Always open CSV files with `newline=""` to avoid formatting issues.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l67', 'Python Unit Testing with unittest', 'developers', 'Python', 'en', 'intermediate', 35, 150, 67, '## Python Unit Testing with unittest

How do you know your code actually works — not just today, but after you change it next week? The answer professional developers rely on is **automated testing**. Today you will learn to write tests using Python''s built-in `unittest` module.

### Why Write Tests?

So far, you have probably tested your code by running it and looking at the output. That works, but it does not scale:

- You have to remember to re-check everything every time you change the code.
- It is easy to miss edge cases (empty input, negative numbers, etc.).
- Other people working on your code do not know what it is *supposed* to do.

A **unit test** is a small piece of code that automatically checks whether a specific "unit" (usually a single function) behaves correctly.

### Your First Test

Suppose you have this function in a file called `calculator.py`:

```python
# calculator.py
def add(a, b):
    return a + b

def divide(a, b):
    if b == 0:
        raise ValueError("Cannot divide by zero")
    return a / b
```

Here is a test file for it:

```python
# test_calculator.py
import unittest
from calculator import add, divide

class TestCalculator(unittest.TestCase):

    def test_add_positive_numbers(self):
        self.assertEqual(add(2, 3), 5)

    def test_add_negative_numbers(self):
        self.assertEqual(add(-2, -3), -5)

    def test_divide_normal(self):
        self.assertEqual(divide(10, 2), 5)

    def test_divide_by_zero_raises_error(self):
        with self.assertRaises(ValueError):
            divide(10, 0)

if __name__ == "__main__":
    unittest.main()
```

Run it from the command line:

```
python -m unittest test_calculator.py
```

If everything passes, you will see something like:

```
....
----------------------------------------------------------------------
Ran 4 tests in 0.001s

OK
```

Each dot represents one passing test. If a test fails, `unittest` shows you exactly which one and why.

### Anatomy of a Test

- A test class inherits from `unittest.TestCase`.
- Every test method name must start with `test_` so `unittest` knows to run it.
- Inside each test, you use **assertion methods** to check expected behavior.

### Common Assertion Methods

| Method | Checks that... |
|---|---|
| `assertEqual(a, b)` | `a == b` |
| `assertNotEqual(a, b)` | `a != b` |
| `assertTrue(x)` | `x` is `True` |
| `assertFalse(x)` | `x` is `False` |
| `assertIsNone(x)` | `x is None` |
| `assertIn(item, container)` | `item` is in `container` |
| `assertRaises(ErrorType)` | the code inside raises `ErrorType` |

### Testing a List Function

```python
# utils.py
def remove_duplicates(items):
    return list(set(items))

def find_max(numbers):
    if not numbers:
        raise ValueError("List is empty")
    return max(numbers)
```

```python
# test_utils.py
import unittest
from utils import remove_duplicates, find_max

class TestUtils(unittest.TestCase):

    def test_remove_duplicates(self):
        result = remove_duplicates([1, 2, 2, 3, 3, 3])
        self.assertEqual(sorted(result), [1, 2, 3])

    def test_find_max_normal_list(self):
        self.assertEqual(find_max([4, 1, 7, 3]), 7)

    def test_find_max_empty_list_raises_error(self):
        with self.assertRaises(ValueError):
            find_max([])

if __name__ == "__main__":
    unittest.main()
```

### setUp(): Running Code Before Every Test

If multiple tests need the same starting data, `setUp()` runs automatically before *each* test method:

```python
import unittest

class TestShoppingCart(unittest.TestCase):

    def setUp(self):
        self.cart = []   # fresh empty cart before every single test

    def test_starts_empty(self):
        self.assertEqual(len(self.cart), 0)

    def test_add_item(self):
        self.cart.append("apple")
        self.assertIn("apple", self.cart)

if __name__ == "__main__":
    unittest.main()
```

### Why Tests Matter for Real Projects

When you write tests for your functions:
- You catch bugs immediately, instead of discovering them later.
- You can change your code confidently — if you break something, a test will fail and tell you.
- Other developers (and your future self!) can read the tests to understand what the code is supposed to do.

### Key Takeaways

- A unit test automatically checks that a small piece of code behaves as expected.
- `unittest.TestCase` is the base class for writing tests; test method names must start with `test_`.
- Use assertion methods like `assertEqual`, `assertTrue`, and `assertRaises` to check expected behavior.
- `setUp()` runs automatically before every test method, useful for preparing fresh test data.
- Run tests from the command line with `python -m unittest test_filename.py`.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;
