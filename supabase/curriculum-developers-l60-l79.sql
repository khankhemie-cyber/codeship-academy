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

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l68', 'Python Virtual Environments and pip', 'developers', 'Python', 'en', 'intermediate', 35, 150, 68, '## Python Virtual Environments and pip

As you build bigger projects, you will want to use code other people have already written — called **packages** or **libraries** — instead of writing everything from scratch. Today you will learn how to install packages with **pip**, and why professional developers isolate each project using a **virtual environment**.

### What Is pip?

`pip` is Python''s package installer. It downloads packages from PyPI (the Python Package Index), a huge online library of free, reusable code, and installs them so you can `import` them in your programs.

```
pip install requests
```

After installing, you can use it in your code:

```python
import requests

response = requests.get("https://api.agify.io?name=nova")
print(response.json())
```

You have already used `requests` in an earlier lesson — now you know how it actually gets onto your computer!

### Checking What Is Installed

```
pip list
```

This shows every package currently installed, along with its version number.

```
pip show requests
```

This shows details about one specific package — its version, location, and dependencies.

### The Problem pip Alone Creates

Imagine you are working on two different projects:

- Project A needs `requests` version 2.25
- Project B needs `requests` version 2.31

If you only have *one* global Python installation, you cannot have two different versions of the same package installed at once — installing one for Project B would break Project A.

### The Solution: Virtual Environments

A **virtual environment** (often called a "venv") is an isolated, self-contained Python setup just for one project. Each project gets its own folder of installed packages, completely separate from every other project and from your computer''s main Python installation.

### Creating a Virtual Environment

```
python -m venv myenv
```

This creates a new folder called `myenv` containing a fresh, isolated copy of Python and pip.

### Activating a Virtual Environment

You need to "activate" it before installing packages into it.

On macOS/Linux:
```
source myenv/bin/activate
```

On Windows:
```
myenv\Scripts\activate
```

Once activated, your terminal prompt usually changes to show the environment name, like `(myenv) $`. Any package you install now goes *only* into this environment.

```
(myenv) $ pip install requests
(myenv) $ pip install pandas
```

### Deactivating

When you are done working on the project:

```
deactivate
```

This returns you to your computer''s normal Python setup.

### Saving and Sharing Your Project''s Dependencies

Professional projects keep a list of required packages in a file called `requirements.txt`, so anyone (including you, on a different computer) can recreate the exact same environment.

Generate it from your active environment:

```
pip freeze > requirements.txt
```

This creates a file like:

```
requests==2.31.0
pandas==2.1.0
```

Someone else can then install everything at once:

```
pip install -r requirements.txt
```

### A Typical Project Workflow

```
mkdir my_project
cd my_project
python -m venv venv
source venv/bin/activate
pip install requests
pip freeze > requirements.txt
```

Now anyone who clones this project can run `pip install -r requirements.txt` inside their own virtual environment and have exactly the right packages, with no version conflicts.

### Why This Matters

- Every real-world Python project you will work on — at a job, in open source, or in college — uses virtual environments.
- It keeps your projects from interfering with each other.
- It makes your project reproducible: anyone, anywhere, can set it up identically.

### Key Takeaways

- `pip` is Python''s tool for installing packages from the internet (PyPI).
- A virtual environment is an isolated Python setup for a single project, preventing version conflicts between projects.
- Create one with `python -m venv venv_name`, then activate it before installing packages.
- `pip freeze > requirements.txt` saves your project''s exact dependencies; `pip install -r requirements.txt` installs them elsewhere.
- Using virtual environments is standard practice for every real Python project.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l69', 'Python Date and Time (datetime module)', 'developers', 'Python', 'en', 'intermediate', 35, 150, 69, '## Python Date and Time (the datetime module)

Almost every real application needs to work with dates and times — birthdays, deadlines, timestamps on messages, countdown timers. Python''s built-in `datetime` module gives you powerful tools for all of this.

### Getting the Current Date and Time

```python
from datetime import datetime

now = datetime.now()
print(now)              # 2026-06-17 14:32:07.123456
print(now.year)         # 2026
print(now.month)        # 6
print(now.day)          # 17
print(now.hour)         # 14
print(now.minute)       # 32
```

### Creating a Specific Date or Time

```python
from datetime import datetime

birthday = datetime(2013, 9, 21)
print(birthday)              # 2013-09-21 00:00:00

meeting = datetime(2026, 6, 20, 15, 30)   # year, month, day, hour, minute
print(meeting)                # 2026-06-20 15:30:00
```

### The date Class (Just the Date, No Time)

```python
from datetime import date

today = date.today()
print(today)            # 2026-06-17

specific_day = date(2025, 12, 25)
print(specific_day)     # 2025-12-25
print(specific_day.weekday())   # 0 = Monday, 6 = Sunday
```

### Formatting Dates as Readable Strings

Use `strftime()` ("string format time") to turn a date/time object into a nicely formatted string:

```python
from datetime import datetime

now = datetime.now()
print(now.strftime("%Y-%m-%d"))           # 2026-06-17
print(now.strftime("%B %d, %Y"))          # June 17, 2026
print(now.strftime("%A, %I:%M %p"))       # Wednesday, 02:32 PM
```

Common format codes:

| Code | Meaning | Example |
|---|---|---|
| `%Y` | 4-digit year | 2026 |
| `%m` | 2-digit month | 06 |
| `%d` | 2-digit day | 17 |
| `%B` | full month name | June |
| `%A` | full weekday name | Wednesday |
| `%H` | hour (24-hour) | 14 |
| `%I` | hour (12-hour) | 02 |
| `%M` | minute | 32 |
| `%p` | AM or PM | PM |

### Parsing Strings Into Dates

Use `strptime()` ("string parse time") to go the other way — turn a text string into a real `datetime` object:

```python
from datetime import datetime

text = "2026-06-17"
parsed = datetime.strptime(text, "%Y-%m-%d")
print(parsed)            # 2026-06-17 00:00:00
print(parsed.year)       # 2026

text2 = "December 25, 2025"
parsed2 = datetime.strptime(text2, "%B %d, %Y")
print(parsed2)            # 2025-12-25 00:00:00
```

The format string must exactly match the layout of the text you are parsing.

### Doing Math With Dates: timedelta

A `timedelta` represents a length of time — useful for adding or subtracting from dates.

```python
from datetime import datetime, timedelta

today = datetime.now()
next_week = today + timedelta(days=7)
print(next_week)

ten_days_ago = today - timedelta(days=10)
print(ten_days_ago)

in_two_hours = today + timedelta(hours=2)
print(in_two_hours)
```

### Finding the Difference Between Two Dates

Subtracting one `datetime` from another gives you a `timedelta`:

```python
from datetime import datetime

start = datetime(2026, 1, 1)
end = datetime(2026, 6, 17)

difference = end - start
print(difference.days)    # 167 (number of days between them)
```

### A Practical Example: Days Until a Birthday

```python
from datetime import date

def days_until_birthday(month, day):
    today = date.today()
    birthday_this_year = date(today.year, month, day)

    if birthday_this_year < today:
        birthday_this_year = date(today.year + 1, month, day)

    return (birthday_this_year - today).days

print(days_until_birthday(12, 25))   # number of days until Dec 25
```

### A Practical Example: Age Calculator

```python
from datetime import date

def calculate_age(birth_year, birth_month, birth_day):
    today = date.today()
    age = today.year - birth_year
    if (today.month, today.day) < (birth_month, birth_day):
        age -= 1
    return age

print(calculate_age(2013, 9, 21))
```

### Key Takeaways

- `datetime.now()` gives the current date and time; `date.today()` gives just today''s date.
- `strftime()` converts a date/time object into a formatted string; `strptime()` parses a string back into a date/time object.
- Format codes like `%Y`, `%m`, `%d`, `%B`, and `%A` control how dates are displayed or parsed.
- `timedelta` represents a duration and can be added to or subtracted from dates.
- Subtracting two dates gives you a `timedelta`, which has a `.days` attribute for counting days between them.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l70', 'Python Intro to SQLite Databases', 'developers', 'Python', 'en', 'intermediate', 35, 150, 70, '## Python Intro to SQLite Databases

You have stored data in lists, dictionaries, and even CSV files. But what happens when your data gets large, needs to be searched quickly, or needs to stay safe even if your program crashes? That is where **databases** come in. Today you will use **SQLite**, a lightweight database built right into Python, with no extra installation required.

### What Is a Database?

A database is an organized system for storing, searching, and updating data, usually arranged into **tables** — similar to spreadsheets, with rows and columns. SQLite stores an entire database in a single file on your computer, which makes it perfect for learning and for smaller projects.

### Connecting to a Database

```python
import sqlite3

connection = sqlite3.connect("school.db")   # creates the file if it doesn''t exist
cursor = connection.cursor()
```

The **connection** represents the link to the database file. The **cursor** is what you use to actually run commands.

### Creating a Table

Tables are defined using SQL (Structured Query Language) — a language designed specifically for working with databases.

```python
cursor.execute(\'\'\'
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        grade INTEGER
    )
\'\'\')
connection.commit()
```

- `PRIMARY KEY AUTOINCREMENT` means SQLite automatically assigns a unique, increasing `id` to every row.
- `TEXT`, `INTEGER` are SQLite''s data types.
- `connection.commit()` saves the changes permanently to the file.

### Inserting Data

```python
cursor.execute(
    "INSERT INTO students (name, age, grade) VALUES (?, ?, ?)",
    ("Amir", 13, 8)
)
connection.commit()
```

Always use `?` placeholders instead of putting values directly into the SQL string — this protects against bugs and a serious security risk called "SQL injection."

Inserting several rows at once:

```python
students = [
    ("Lina", 12, 7),
    ("Theo", 14, 8),
    ("Sam", 13, 8),
]
cursor.executemany(
    "INSERT INTO students (name, age, grade) VALUES (?, ?, ?)",
    students
)
connection.commit()
```

### Querying Data

```python
cursor.execute("SELECT * FROM students")
rows = cursor.fetchall()
for row in rows:
    print(row)
# (1, ''Amir'', 13, 8)
# (2, ''Lina'', 12, 7)
# (3, ''Theo'', 14, 8)
# (4, ''Sam'', 13, 8)
```

`fetchall()` returns every matching row as a list of tuples. `fetchone()` returns just the next single row.

### Filtering With WHERE

```python
cursor.execute("SELECT * FROM students WHERE grade = ?", (8,))
grade_8_students = cursor.fetchall()
print(grade_8_students)
```

### Updating Data

```python
cursor.execute(
    "UPDATE students SET age = ? WHERE name = ?",
    (14, "Amir")
)
connection.commit()
```

### Deleting Data

```python
cursor.execute("DELETE FROM students WHERE name = ?", ("Sam",))
connection.commit()
```

### Closing the Connection

When you are done, always close the connection to make sure everything is saved properly:

```python
connection.close()
```

### A Practical Example: Putting It All Together

```python
import sqlite3

connection = sqlite3.connect("school.db")
cursor = connection.cursor()

cursor.execute(\'\'\'
    CREATE TABLE IF NOT EXISTS students (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        age INTEGER,
        grade INTEGER
    )
\'\'\')

cursor.execute("INSERT INTO students (name, age, grade) VALUES (?, ?, ?)", ("Nova", 13, 8))
connection.commit()

cursor.execute("SELECT name, age FROM students WHERE grade = ?", (8,))
for name, age in cursor.fetchall():
    print(f"{name} is {age} years old")

connection.close()
```

### Why SQLite Matters

Real applications — including most mobile apps — use SQLite to store data locally. Learning it now gives you the foundation you will need later in this course when you explore full SQL and bigger databases.

### Key Takeaways

- A database organizes data into tables made of rows and columns, and SQLite stores an entire database as a single file.
- `sqlite3.connect()` opens (or creates) a database file; `cursor.execute()` runs SQL commands.
- Use `?` placeholders with a tuple of values when inserting or filtering data — never insert values directly into the SQL string.
- `fetchall()` retrieves every matching row; `fetchone()` retrieves just one.
- Always call `connection.commit()` after changes and `connection.close()` when finished.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l71', 'Python Mini-Project: Address Book App', 'developers', 'Python', 'en', 'intermediate', 35, 150, 71, '## Python Mini-Project: Address Book App

It is time to combine many of the skills you have built over the last several lessons — functions, dictionaries, file handling, JSON, and even SQLite — into one complete, useful program: a command-line **Address Book** app.

### Planning the Project

Before writing code, let''s plan what our address book needs to do:

1. Add a new contact (name, phone, email)
2. View all contacts
3. Search for a contact by name
4. Delete a contact
5. Save contacts so they are still there next time the program runs

We will start with a simple in-memory + JSON file version, which reinforces file I/O and JSON skills from earlier lessons.

### Step 1: Data Structure

We will store each contact as a dictionary, and all contacts in a list:

```python
contacts = [
    {"name": "Amir", "phone": "555-1234", "email": "amir@email.com"},
    {"name": "Lina", "phone": "555-5678", "email": "lina@email.com"},
]
```

### Step 2: Loading and Saving With JSON

```python
import json
import os

FILENAME = "contacts.json"

def load_contacts():
    if not os.path.exists(FILENAME):
        return []
    with open(FILENAME, "r") as f:
        return json.load(f)

def save_contacts(contacts):
    with open(FILENAME, "w") as f:
        json.dump(contacts, f, indent=2)
```

### Step 3: Adding a Contact

```python
def add_contact(contacts):
    name = input("Name: ")
    phone = input("Phone: ")
    email = input("Email: ")
    contacts.append({"name": name, "phone": phone, "email": email})
    save_contacts(contacts)
    print(f"Added {name} to your address book.")
```

### Step 4: Viewing All Contacts

```python
def view_contacts(contacts):
    if not contacts:
        print("Your address book is empty.")
        return
    for i, contact in enumerate(contacts, start=1):
        print(f"{i}. {contact[''name'']} — {contact[''phone'']} — {contact[''email'']}")
```

### Step 5: Searching for a Contact

```python
def search_contact(contacts):
    query = input("Search by name: ").lower()
    results = [c for c in contacts if query in c["name"].lower()]
    if results:
        for contact in results:
            print(f"{contact[''name'']} — {contact[''phone'']} — {contact[''email'']}")
    else:
        print("No matching contacts found.")
```

### Step 6: Deleting a Contact

```python
def delete_contact(contacts):
    name = input("Name to delete: ").lower()
    matching = [c for c in contacts if c["name"].lower() == name]
    if not matching:
        print("No contact found with that name.")
        return
    contacts.remove(matching[0])
    save_contacts(contacts)
    print(f"Deleted {matching[0][''name'']}.")
```

### Step 7: The Main Menu Loop

```python
def main():
    contacts = load_contacts()

    while True:
        print("\\n--- Address Book ---")
        print("1. Add contact")
        print("2. View all contacts")
        print("3. Search contacts")
        print("4. Delete a contact")
        print("5. Quit")

        choice = input("Choose an option: ")

        if choice == "1":
            add_contact(contacts)
        elif choice == "2":
            view_contacts(contacts)
        elif choice == "3":
            search_contact(contacts)
        elif choice == "4":
            delete_contact(contacts)
        elif choice == "5":
            print("Goodbye!")
            break
        else:
            print("Invalid option, please try again.")

if __name__ == "__main__":
    main()
```

### Putting the Whole Program Together

Combine every function above (`load_contacts`, `save_contacts`, `add_contact`, `view_contacts`, `search_contact`, `delete_contact`, and `main`) into a single file called `address_book.py`, with `main()` called at the bottom using the `if __name__ == "__main__":` guard. Running it gives you a fully working, menu-driven app that remembers your contacts between runs because everything is saved to `contacts.json`.

### Ideas to Extend This Project

Once your basic version works, try adding:

- **Editing** an existing contact''s phone or email
- **Sorting** contacts alphabetically before displaying them
- **Validation** so empty names or badly formatted phone numbers are rejected
- Switching from a JSON file to a **SQLite database** (using what you learned last lesson) so the app can handle thousands of contacts efficiently

### Why This Project Matters

This is your first project that brings together input/output, persistent storage, functions, and a menu-driven loop — the same basic shape used by countless real command-line tools. Being comfortable building something like this from scratch is a major milestone.

### Key Takeaways

- Breaking a big project into small functions (`add_contact`, `view_contacts`, `search_contact`, `delete_contact`) makes it far easier to build and debug.
- Saving data to a JSON file after every change means your program''s data survives between runs.
- A `while True` loop with a menu of numbered choices is a common, simple way to structure an interactive command-line program.
- List comprehensions (from earlier lessons) make searching and filtering contacts concise and readable.
- This project pattern — menu loop + persistent storage + CRUD operations (Create, Read, Update, Delete) — appears throughout real-world software.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l72', 'Python Algorithms: Linear and Binary Search', 'developers', 'Python', 'en', 'intermediate', 35, 150, 72, '## Python Algorithms: Linear and Binary Search

You have been searching through lists for many lessons now, usually with `in` or a loop. Today you will look "under the hood" at two specific **search algorithms** — step-by-step methods for finding something — and learn why one can be dramatically faster than the other.

### What Is an Algorithm?

An algorithm is simply a precise set of steps for solving a problem. You already write algorithms every time you write a function! Today''s lesson focuses on comparing two different algorithms that solve the *same* problem (finding a value in a list) in different ways.

### Linear Search

Linear search checks every item, one at a time, from the beginning, until it finds a match (or reaches the end).

```python
def linear_search(items, target):
    for index, value in enumerate(items):
        if value == target:
            return index
    return -1   # not found

numbers = [4, 8, 15, 16, 23, 42]
print(linear_search(numbers, 23))   # 4
print(linear_search(numbers, 99))   # -1
```

Linear search works on **any** list, sorted or not. But in the worst case (the item is last, or missing entirely), it has to check every single item.

### Binary Search

Binary search is much faster, but only works on a **sorted** list. Instead of checking every item, it repeatedly looks at the *middle* item and eliminates half of the remaining list each time.

The idea: "Pick a number between 1 and 100" guessing games work this way — guess 50, get told higher or lower, then guess 75 or 25, and so on. You narrow the possibilities in half every guess.

```python
def binary_search(items, target):
    low = 0
    high = len(items) - 1

    while low <= high:
        mid = (low + high) // 2
        if items[mid] == target:
            return mid
        elif items[mid] < target:
            low = mid + 1     # target must be in the right half
        else:
            high = mid - 1    # target must be in the left half

    return -1   # not found

numbers = [4, 8, 15, 16, 23, 42, 50, 71, 89]
print(binary_search(numbers, 42))   # 5
print(binary_search(numbers, 100))  # -1
```

### Tracing Through Binary Search

Let''s search for `23` in `[4, 8, 15, 16, 23, 42, 50, 71, 89]` (indexes 0-8):

```
low = 0, high = 8, mid = 4 -> items[4] = 23 -> FOUND at index 4!
```

That only took one step! Now let''s search for `71`:

```
low = 0, high = 8, mid = 4 -> items[4] = 23, target (71) is bigger -> search right half
low = 5, high = 8, mid = 6 -> items[6] = 50, target (71) is bigger -> search right half
low = 7, high = 8, mid = 7 -> items[7] = 71 -> FOUND at index 7!
```

Three steps, in a list of 9 items. Linear search would have taken up to 8 steps in the worst case.

### Why Binary Search Is So Much Faster

Every step of binary search cuts the remaining possibilities in half. For a list of 1,000 items:

- Linear search: up to 1,000 checks
- Binary search: only about 10 checks! (because 2^10 = 1024)

For a list of 1,000,000 items:

- Linear search: up to 1,000,000 checks
- Binary search: only about 20 checks! (because 2^20 ≈ 1,000,000)

This kind of efficiency difference is exactly why computer scientists study algorithms — the right algorithm can turn an impossibly slow program into an instant one.

### The Catch: Binary Search Needs Sorted Data

```python
numbers = [42, 8, 23, 4, 16]   # NOT sorted
print(binary_search(numbers, 23))   # may give the WRONG answer!
```

If the list is not sorted, binary search''s "eliminate half" logic breaks down completely. You must sort the list first (we will cover sorting algorithms in the next lesson), which has its own cost — but if you are going to search the *same* list many times, sorting once and using binary search repeatedly is well worth it.

### Comparing the Two

| | Linear Search | Binary Search |
|---|---|---|
| Requires sorted data? | No | Yes |
| Worst case for 1,000 items | 1,000 checks | ~10 checks |
| Works on any list | Yes | Only sorted |
| Code complexity | Very simple | Slightly more complex |

### Key Takeaways

- Linear search checks every item one by one and works on any list, sorted or not.
- Binary search repeatedly checks the middle item and eliminates half the remaining list each step — but it only works on sorted data.
- Binary search is dramatically faster for large lists: roughly 20 steps for a million items, versus up to a million steps for linear search.
- Choosing the right algorithm for the situation can make the difference between a program that is instant and one that is painfully slow.
- This idea — measuring how an algorithm''s speed grows with input size — is the foundation of a topic called "Big O notation," which you will explore more in future lessons.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l73', 'Python Algorithms: Sorting (Bubble, Selection, Intro to Quicksort)', 'developers', 'Python', 'en', 'intermediate', 35, 150, 73, '## Python Algorithms: Sorting

Last lesson, binary search needed a sorted list to work its magic. But how does a list actually *get* sorted? Today you will write three classic **sorting algorithms** from scratch: bubble sort, selection sort, and a first look at quicksort.

### Bubble Sort

Bubble sort repeatedly steps through the list, comparing neighboring pairs and swapping them if they are in the wrong order. Larger values "bubble" toward the end with each pass.

```python
def bubble_sort(items):
    items = items.copy()
    n = len(items)

    for i in range(n):
        for j in range(0, n - i - 1):
            if items[j] > items[j + 1]:
                items[j], items[j + 1] = items[j + 1], items[j]

    return items

numbers = [5, 2, 9, 1, 5, 6]
print(bubble_sort(numbers))   # [1, 2, 5, 5, 6, 9]
```

Why `n - i - 1`? After each full pass, the largest remaining value has already "bubbled" to its correct spot at the end, so we don''t need to check it again.

Bubble sort is simple to understand but slow for large lists — it is mainly taught because it is the clearest introduction to how sorting algorithms think.

### Selection Sort

Selection sort repeatedly finds the smallest remaining value and moves it to the front.

```python
def selection_sort(items):
    items = items.copy()
    n = len(items)

    for i in range(n):
        min_index = i
        for j in range(i + 1, n):
            if items[j] < items[min_index]:
                min_index = j
        items[i], items[min_index] = items[min_index], items[i]

    return items

numbers = [5, 2, 9, 1, 5, 6]
print(selection_sort(numbers))   # [1, 2, 5, 5, 6, 9]
```

Trace through it: on the first pass, it scans the whole list and finds `1` is the smallest, swapping it to the front. On the second pass, it scans everything *except* the first item and finds the next smallest, and so on.

### Comparing Bubble Sort and Selection Sort

Both algorithms are similar in speed (roughly checking every pair of items), but selection sort does fewer total swaps, since it only swaps once per pass instead of repeatedly during the pass.

### Quicksort: A Faster Approach

Quicksort uses a smarter strategy: pick a "pivot" value, then split the rest of the list into "smaller than pivot" and "larger than pivot" groups, and recursively sort each group.

```python
def quicksort(items):
    if len(items) <= 1:
        return items   # base case: 0 or 1 items are already sorted

    pivot = items[len(items) // 2]
    smaller = [x for x in items if x < pivot]
    equal = [x for x in items if x == pivot]
    larger = [x for x in items if x > pivot]

    return quicksort(smaller) + equal + quicksort(larger)

numbers = [5, 2, 9, 1, 5, 6]
print(quicksort(numbers))   # [1, 2, 5, 5, 6, 9]
```

Notice this uses **recursion** (from our earlier lesson) — quicksort calls itself on smaller and smaller sublists until it hits the base case of a list with 0 or 1 items.

### Tracing Quicksort

```
quicksort([5, 2, 9, 1, 5, 6])
pivot = 1 (the middle item, index 3)
smaller = [] (nothing is less than 1... wait, let''s use the actual middle)
```

Let''s trace more carefully — the middle index of `[5, 2, 9, 1, 5, 6]` (length 6) is index 3, so `pivot = 1`:

```
smaller = []          (nothing less than 1)
equal   = [1]
larger  = [5, 2, 9, 5, 6]

quicksort(larger) splits again with a new pivot from THAT list, and so on,
until everything is broken down into pieces of size 0 or 1.
```

Each recursive call works on a smaller list, and the results get combined back together with `+`.

### Why Quicksort Is Usually Faster

Bubble sort and selection sort both compare almost every pair of items, taking roughly `n * n` total comparisons for a list of `n` items. Quicksort, by splitting the list in a smart way, typically only needs roughly `n * log(n)` comparisons — a huge improvement for large lists, similar in spirit to why binary search beat linear search last lesson.

| | Bubble Sort | Selection Sort | Quicksort |
|---|---|---|---|
| Typical speed | Slow | Slow | Fast |
| Easy to understand | Very easy | Easy | Moderate |
| Uses recursion | No | No | Yes |
| Used in real-world libraries | Rarely | Rarely | Often (in optimized forms) |

### Python''s Built-In Sorting

In real projects, you would almost never write your own sorting algorithm — Python''s built-in `sorted()` and `.sort()` are highly optimized (using an algorithm called Timsort) and should always be your first choice:

```python
numbers = [5, 2, 9, 1, 5, 6]
print(sorted(numbers))   # [1, 2, 5, 5, 6, 9]
```

We write our own versions in this lesson so you understand *how* sorting works underneath — this understanding is valuable for technical interviews and for building intuition about algorithm performance.

### Key Takeaways

- Bubble sort repeatedly swaps neighboring out-of-order pairs, "bubbling" the largest values to the end.
- Selection sort repeatedly finds the smallest remaining value and moves it into place.
- Quicksort recursively splits the list around a pivot value into smaller and larger groups, which is typically much faster for large lists.
- In real projects, use Python''s built-in `sorted()`/`.sort()` rather than hand-written sorting algorithms.
- Understanding how these algorithms work builds intuition about *why* some code runs fast and other code runs slow.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l74', 'Python Milestone Review and Practice', 'developers', 'Python', 'en', 'intermediate', 35, 150, 74, '## Python Milestone Review and Practice

You have covered an enormous amount of ground over the last fourteen lessons — recursion, lambdas, decorators, generators, regular expressions, JSON and APIs, CSV files, unit testing, virtual environments, dates and times, SQLite, a full mini-project, and two lessons on algorithms. This lesson is a milestone checkpoint: a chance to review the big ideas and practice combining them before we shift toward command-line tools, web requests, and databases.

### Quick Reference: What You Have Learned

**Recursion** — a function calling itself with a smaller version of a problem, always needing a base case:

```python
def factorial(n):
    if n == 0:
        return 1
    return n * factorial(n - 1)
```

**Lambda, map, filter** — short, throwaway functions and tools for transforming/filtering data:

```python
nums = [1, 2, 3, 4, 5, 6]
evens_squared = list(map(lambda x: x ** 2, filter(lambda x: x % 2 == 0, nums)))
```

**Decorators** — functions that wrap other functions to add behavior:

```python
def shout(func):
    def wrapper(text):
        return func(text).upper() + "!"
    return wrapper

@shout
def greet(name):
    return f"hello, {name}"
```

**Generators** — functions that `yield` values one at a time instead of building a whole list:

```python
def countdown(n):
    while n > 0:
        yield n
        n -= 1
```

**Regular expressions** — pattern matching in text using the `re` module:

```python
import re
prices = re.findall(r"\d+", "Apples: 3, Oranges: 5")
```

**JSON and APIs** — converting data with `json.dumps()`/`json.loads()`, and fetching live data with `requests.get()`.

**CSV files** — reading/writing spreadsheet-like data with `csv.DictReader`/`csv.DictWriter`.

**Unit testing** — automatically checking code correctness with `unittest.TestCase` and assertion methods.

**Virtual environments and pip** — isolating each project''s installed packages with `python -m venv` and `pip install`.

**datetime** — working with dates, times, formatting (`strftime`), parsing (`strptime`), and durations (`timedelta`).

**SQLite** — a lightweight, file-based database accessed through `sqlite3`, using SQL commands like `CREATE TABLE`, `INSERT`, `SELECT`, `UPDATE`, `DELETE`.

**Search and sort algorithms** — linear vs. binary search, and bubble/selection/quicksort, plus why algorithm choice affects performance.

### Practice Challenge 1: Recursive Word Counter

Write a recursive function that counts how many words are in a nested list of strings (similar to the nested-list counting example from the recursion lesson):

```python
def count_words(data):
    total = 0
    for item in data:
        if isinstance(item, list):
            total += count_words(item)
        else:
            total += len(item.split())
    return total

sentences = ["hello world", ["how are you", "I am fine"], "goodbye"]
print(count_words(sentences))   # 2 + (3 + 3) + 1 = 9
```

### Practice Challenge 2: Filter and Transform API-Style Data

Combine `map()`/`filter()` (or a list comprehension) with dictionary data, similar to what you might get back from a real API:

```python
students = [
    {"name": "Amir", "grade": 8, "score": 92},
    {"name": "Lina", "grade": 7, "score": 78},
    {"name": "Theo", "grade": 8, "score": 99},
]

honor_roll = [s["name"] for s in students if s["score"] >= 90]
print(honor_roll)   # ["Amir", "Theo"]
```

### Practice Challenge 3: A Tiny Test Suite

Write a function and a matching `unittest` test, just like in the unit testing lesson:

```python
def is_palindrome(text):
    cleaned = text.lower().replace(" ", "")
    return cleaned == cleaned[::-1]

import unittest

class TestPalindrome(unittest.TestCase):
    def test_simple_palindrome(self):
        self.assertTrue(is_palindrome("racecar"))

    def test_phrase_palindrome(self):
        self.assertTrue(is_palindrome("nurses run"))

    def test_not_palindrome(self):
        self.assertFalse(is_palindrome("hello"))

if __name__ == "__main__":
    unittest.main()
```

### Practice Challenge 4: Search and Sort Together

```python
def binary_search(items, target):
    low, high = 0, len(items) - 1
    while low <= high:
        mid = (low + high) // 2
        if items[mid] == target:
            return mid
        elif items[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

unsorted_scores = [88, 45, 67, 92, 71, 53]
sorted_scores = sorted(unsorted_scores)
print(sorted_scores)
print(binary_search(sorted_scores, 71))
```

### Self-Check Questions

Before moving on, make sure you can confidently answer:

1. What two things does every recursive function need?
2. What is the difference between `map()`/`filter()` and a list comprehension?
3. What does the `@` symbol do above a function definition?
4. Why are generators more memory-efficient than building a full list?
5. What is the difference between `json.dumps()` and `json.dump()`?
6. Why should you always use a virtual environment for a new project?
7. Why does binary search require sorted data, but linear search does not?

### What''s Next

You now have a strong foundation in core and intermediate Python. Starting next lesson, we begin shifting toward the tools professional developers use every day outside of just the Python language itself: the command line, Git branching, HTTP and APIs in more depth, building your own web API with Flask, and finally, real SQL databases. Everything you have learned so far — functions, data structures, files, testing — will be the foundation for all of it.

### Key Takeaways

- Recursion, lambdas/map/filter, decorators, and generators are all different tools for writing flexible, reusable functions.
- JSON, CSV, and SQLite are three common ways real applications store and exchange data.
- Unit testing and virtual environments are professional habits that make your code reliable and reproducible.
- Search and sort algorithms show that *how* you solve a problem can matter as much as *whether* you solve it.
- You are now ready to move from "Python the language" toward "Python in the real world" — command lines, APIs, web servers, and databases.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l75', 'Intro to the Command Line for Developers', 'developers', 'Command Line', 'en', 'intermediate', 35, 150, 75, '## Intro to the Command Line for Developers

So far, you have mostly run your Python programs through an editor''s "Run" button. Professional developers spend much of their time in the **command line** (also called the terminal or shell) — a text-based way of controlling your computer. Today you will learn the essential commands every developer needs.

### What Is the Command Line?

The command line is a program that lets you type text commands instead of clicking icons. It might look intimidating at first — just a blinking cursor on a black or white screen — but it is one of the most powerful tools you will use as a developer. It lets you run programs, manage files, install software, and use tools like Git, all from text commands.

### Navigating the File System

| Command | Meaning |
|---|---|
| `pwd` | "print working directory" — shows where you currently are |
| `ls` | "list" — shows the files/folders in the current directory |
| `cd foldername` | "change directory" — moves into a folder |
| `cd ..` | moves up one folder (to the parent) |
| `cd ~` | moves to your home directory |

```
$ pwd
/home/student/projects

$ ls
address_book.py   contacts.json   notes.txt

$ cd address_book_project
$ pwd
/home/student/projects/address_book_project

$ cd ..
$ pwd
/home/student/projects
```

### Working With Files and Folders

| Command | Meaning |
|---|---|
| `mkdir name` | "make directory" — creates a new folder |
| `touch file.txt` | creates a new, empty file |
| `rm file.txt` | "remove" — deletes a file (careful, this is permanent!) |
| `rm -r foldername` | deletes a folder and everything inside it |
| `cp source dest` | "copy" — copies a file |
| `mv source dest` | "move" — moves or renames a file |

```
$ mkdir my_new_project
$ cd my_new_project
$ touch main.py
$ ls
main.py

$ cp main.py backup.py
$ ls
main.py   backup.py

$ mv backup.py old_main.py
$ ls
main.py   old_main.py
```

### Viewing File Contents

| Command | Meaning |
|---|---|
| `cat file.txt` | prints the entire file to the screen |
| `head file.txt` | shows the first 10 lines |
| `tail file.txt` | shows the last 10 lines |

```
$ cat notes.txt
Remember to study for the algorithms quiz!
```

### Running Python Programs From the Command Line

You have probably been doing this already without thinking of it as "the command line":

```
$ python address_book.py
```

or, depending on your system:

```
$ python3 address_book.py
```

### Useful Extras

```
$ clear           # clears the terminal screen
$ history         # shows recently run commands
$ echo "hello"    # prints text to the screen
```

### Combining Commands

You can chain simple commands together. For example, create a folder, move into it, and create a file, all in one line using `&&` (which means "and then, only if the previous command succeeded"):

```
$ mkdir new_project && cd new_project && touch app.py
```

### A Practical Example: Setting Up a New Project

```
$ mkdir weather_app
$ cd weather_app
$ python -m venv venv
$ source venv/bin/activate
$ pip install requests
$ touch weather.py
$ ls
venv   weather.py
```

This single sequence — using commands from this lesson plus the virtual environment lesson — is exactly how a real developer starts a brand-new project.

### Why the Command Line Matters

- It is often faster than clicking through folders and menus.
- Many essential developer tools (Git, pip, deployment tools) are command-line only, or work best that way.
- It lets you automate repetitive tasks.
- It is the same basic toolkit whether you are on a laptop or working on a powerful remote server.

### Key Takeaways

- The command line lets you navigate, create, and manage files using typed commands instead of clicking.
- `pwd`, `ls`, and `cd` are the core navigation commands.
- `mkdir`, `touch`, `rm`, `cp`, and `mv` manage files and folders.
- `cat`, `head`, and `tail` let you view file contents without opening an editor.
- The `&&` operator chains commands together, running the next one only if the previous one succeeded.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l76', 'Git Branching and Merging', 'developers', 'Command Line', 'en', 'intermediate', 35, 150, 76, '## Git Branching and Merging

You have used Git before to track changes and save versions of your projects. Today you will learn one of Git''s most powerful features: **branching** — the ability to work on new ideas or features in an isolated copy of your project, without disturbing the main, working version.

### What Is a Branch?

Think of your project''s history as a timeline. A **branch** is a separate timeline that starts from a specific point and can grow independently. The default branch is usually called `main` (sometimes `master`). When you create a new branch, you get a safe space to experiment — if something goes wrong, `main` is untouched.

### Why Branch Instead of Just Editing main?

Imagine you are adding a brand-new feature to your address book app, like sorting contacts alphabetically. If you edit `main` directly and something breaks halfway through, your whole project is broken. If you do the work on a separate branch instead, `main` stays safe and working the entire time.

### Checking Your Current Branch

```
$ git branch
* main
```

The `*` shows which branch you are currently on.

### Creating a New Branch

```
$ git branch add-sorting-feature
$ git branch
  add-sorting-feature
* main
```

This creates the branch, but you are still on `main` (notice the `*` is still next to `main`).

### Switching Branches

```
$ git checkout add-sorting-feature
Switched to branch ''add-sorting-feature''

$ git branch
* add-sorting-feature
  main
```

A shortcut combines both steps — create *and* switch to a new branch in one command:

```
$ git checkout -b add-sorting-feature
```

(In newer versions of Git, `git switch -c add-sorting-feature` does the same thing.)

### Making Changes on Your Branch

Once on your new branch, work exactly like normal — edit files, then `add` and `commit`:

```
$ git add address_book.py
$ git commit -m "Add alphabetical sorting to contact list"
```

This commit only exists on `add-sorting-feature`. If you switch back to `main`, your code there will look exactly like it did before you started.

```
$ git checkout main
```

Your sorting feature is not there — it is safely tucked away on the other branch, waiting for you.

### Merging: Bringing Your Branch''s Work Into main

Once your feature works and you are happy with it, you **merge** it back into `main`:

```
$ git checkout main
$ git merge add-sorting-feature
```

This brings all the commits from `add-sorting-feature` into `main`. Now `main` has the sorting feature too.

### Deleting a Branch After Merging

Once a branch has been merged and you no longer need it, it is good practice to delete it to keep things tidy:

```
$ git branch -d add-sorting-feature
```

### Merge Conflicts

Sometimes Git cannot automatically combine two branches — for example, if both branches changed the *same line* of the *same file* in different ways. This is called a **merge conflict**, and Git will mark it directly in the file:

```python
<<<<<<< HEAD
def greet(name):
    return f"Hello, {name}!"
=======
def greet(name):
    return f"Hi there, {name}!"
>>>>>>> add-sorting-feature
```

To resolve it, you manually edit the file to keep the version you want (or a combination), remove the `<<<<<<<`, `=======`, and `>>>>>>>` markers, then add and commit the result:

```
$ git add address_book.py
$ git commit -m "Resolve merge conflict in greet function"
```

### A Typical Branching Workflow

```
$ git checkout -b add-search-feature
# ...edit files, test your changes...
$ git add .
$ git commit -m "Add contact search feature"
$ git checkout main
$ git merge add-search-feature
$ git branch -d add-search-feature
```

This pattern — branch, work, commit, merge, delete — is used by professional developers on every single feature, bug fix, or experiment, often dozens of times a day on large teams.

### Why This Matters for Teams

When multiple people work on the same project, branches let everyone work on different features at the same time without stepping on each other''s changes. Each person merges their finished work into `main` when it is ready, often after their teammates review it (you will see this idea again if you ever submit a "pull request" on GitHub).

### Key Takeaways

- A branch is an independent timeline of commits, letting you work on new features without affecting `main`.
- `git checkout -b branch-name` creates and switches to a new branch in one step.
- `git merge branch-name` (run while on the branch you want to merge *into*, usually `main`) combines another branch''s history into the current one.
- A merge conflict happens when Git cannot automatically combine changes — you resolve it by manually editing the file and removing the conflict markers.
- Branching and merging are the foundation of how real development teams collaborate safely on shared codebases.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l77', 'Intro to APIs and HTTP Methods (GET/POST/PUT/DELETE)', 'developers', 'Web Development', 'en', 'intermediate', 35, 150, 77, '## Intro to APIs and HTTP Methods

You have already used `requests.get()` to fetch data from an API. Today you will go deeper into how the web actually communicates, learning about **HTTP** (the protocol the entire web is built on) and its four most important methods: GET, POST, PUT, and DELETE.

### What Is HTTP?

HTTP (HyperText Transfer Protocol) is the set of rules that web browsers, apps, and servers use to talk to each other. Every time you visit a website or an app fetches data, it is making an HTTP **request** to a server, which sends back an HTTP **response**.

A request has:
- A **URL** — the address of the resource (e.g., `https://api.example.com/students/42`)
- A **method** — what you want to do (get data? create something? change something? delete something?)
- Sometimes a **body** — data being sent, like a new student''s information

A response has:
- A **status code** — a number telling you what happened (`200` success, `404` not found, `500` server error)
- A **body** — usually JSON data

### The Four Core HTTP Methods

| Method | Purpose | Example |
|---|---|---|
| `GET` | Retrieve data | Get a list of students |
| `POST` | Create new data | Add a new student |
| `PUT` | Update existing data | Change a student''s grade |
| `DELETE` | Remove data | Delete a student record |

This pattern — GET, POST, PUT, DELETE — is often remembered by the acronym **CRUD**: Create, Read, Update, Delete.

### GET: Reading Data

You have already used this:

```python
import requests

response = requests.get("https://api.agify.io?name=nova")
print(response.status_code)   # 200
print(response.json())
```

GET requests should never change anything on the server — they only *read* data.

### POST: Creating New Data

POST sends data *to* the server, usually to create something new. You include a body with the data:

```python
import requests

new_post = {
    "title": "My First Post",
    "body": "This is the content of my post.",
    "userId": 1
}

response = requests.post("https://jsonplaceholder.typicode.com/posts", json=new_post)
print(response.status_code)   # 201 means "Created"
print(response.json())
```

Status code `201` specifically means something new was successfully created.

### PUT: Updating Existing Data

PUT updates something that already exists, usually identified by an ID in the URL:

```python
import requests

updated_post = {
    "id": 1,
    "title": "Updated Title",
    "body": "Updated content.",
    "userId": 1
}

response = requests.put("https://jsonplaceholder.typicode.com/posts/1", json=updated_post)
print(response.status_code)   # 200
print(response.json())
```

### DELETE: Removing Data

```python
import requests

response = requests.delete("https://jsonplaceholder.typicode.com/posts/1")
print(response.status_code)   # 200, meaning the deletion was successful
```

### Common HTTP Status Codes

| Code | Category | Meaning |
|---|---|---|
| `200` | Success | OK, the request worked |
| `201` | Success | Created — something new was made |
| `400` | Client Error | Bad Request — something was wrong with your request |
| `401` | Client Error | Unauthorized — you need to log in |
| `404` | Client Error | Not Found — the resource doesn''t exist |
| `500` | Server Error | Something went wrong on the server''s side |

A simple rule of thumb: codes starting with `2` mean success, `4` means *you* made a mistake (bad URL, missing data), and `5` means the *server* made a mistake.

### A Practical Example: A Mini Student API Client

```python
import requests

BASE_URL = "https://jsonplaceholder.typicode.com"

def get_all_posts():
    response = requests.get(f"{BASE_URL}/posts")
    return response.json()

def create_post(title, body, user_id):
    data = {"title": title, "body": body, "userId": user_id}
    response = requests.post(f"{BASE_URL}/posts", json=data)
    return response.json()

def update_post(post_id, title, body, user_id):
    data = {"id": post_id, "title": title, "body": body, "userId": user_id}
    response = requests.put(f"{BASE_URL}/posts/{post_id}", json=data)
    return response.json()

def delete_post(post_id):
    response = requests.delete(f"{BASE_URL}/posts/{post_id}")
    return response.status_code

posts = get_all_posts()
print(f"Found {len(posts)} posts")

new_post = create_post("Hello", "My first API post!", 1)
print(new_post)
```

### Why This Matters

Every app on your phone, every website you visit, and every modern piece of software relies on HTTP and these four methods to move data around. Understanding GET/POST/PUT/DELETE is essential before building your own web API in the next lesson, where you will be the one *receiving* these requests instead of just sending them.

### Key Takeaways

- HTTP is the protocol used for almost all communication on the web, made up of requests and responses.
- GET retrieves data, POST creates new data, PUT updates existing data, and DELETE removes data — together known as CRUD operations.
- Status codes starting with 2 mean success, 4 means a client-side error, and 5 means a server-side error.
- The `requests` library supports all four methods: `requests.get()`, `requests.post()`, `requests.put()`, `requests.delete()`.
- Understanding these methods is the foundation for building your own web API, which is exactly what comes next.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l78', 'Building a Simple REST API with Flask', 'developers', 'Web Development', 'en', 'intermediate', 35, 150, 78, '## Building a Simple REST API with Flask

You have *used* APIs by sending GET, POST, PUT, and DELETE requests. Now you will flip to the other side and *build* your own API using **Flask**, a lightweight Python web framework. By the end of this lesson, you will have a working web server that responds to real HTTP requests.

### What Is Flask?

Flask is a Python library that makes it easy to build web applications and APIs. It listens for HTTP requests and lets you write Python functions that decide how to respond — using the `@app.route()` decorator you are now prepared to recognize from the decorators lesson!

### Installing Flask

```
pip install flask
```

(Remember to do this inside an activated virtual environment, as you learned earlier.)

### Your First Flask App

```python
# app.py
from flask import Flask

app = Flask(__name__)

@app.route("/")
def home():
    return "Hello, world! This is my first API."

if __name__ == "__main__":
    app.run(debug=True)
```

Run it with:

```
python app.py
```

Then visit `http://127.0.0.1:5000/` in a browser, or use `requests.get("http://127.0.0.1:5000/")` from another Python script. You will see your message!

`debug=True` automatically restarts the server when you change your code, which is very handy while building.

### Returning JSON

Real APIs almost always respond with JSON, not plain text. Flask has a built-in helper for this:

```python
from flask import Flask, jsonify

app = Flask(__name__)

students = [
    {"id": 1, "name": "Amir", "grade": 8},
    {"id": 2, "name": "Lina", "grade": 7},
]

@app.route("/students")
def get_students():
    return jsonify(students)

if __name__ == "__main__":
    app.run(debug=True)
```

Visiting `/students` now returns a proper JSON array, exactly like the real APIs you have already used.

### Handling URL Parameters

You can build dynamic routes that take part of the URL as input:

```python
@app.route("/students/<int:student_id>")
def get_student(student_id):
    for student in students:
        if student["id"] == student_id:
            return jsonify(student)
    return jsonify({"error": "Student not found"}), 404
```

Visiting `/students/1` returns Amir''s data. Visiting `/students/999` returns a 404 error, just like real APIs do.

### Handling POST Requests (Creating Data)

To accept data, you need to tell Flask which HTTP methods a route allows, and read the incoming JSON body using `request`:

```python
from flask import Flask, jsonify, request

app = Flask(__name__)

students = [
    {"id": 1, "name": "Amir", "grade": 8},
]

@app.route("/students", methods=["GET", "POST"])
def students_route():
    if request.method == "POST":
        new_student = request.get_json()
        new_student["id"] = len(students) + 1
        students.append(new_student)
        return jsonify(new_student), 201
    return jsonify(students)

if __name__ == "__main__":
    app.run(debug=True)
```

Now, sending a POST request with a JSON body like `{"name": "Theo", "grade": 8}` to `/students` adds a new student and responds with `201 Created` — exactly the behavior you learned about in the previous lesson.

### Handling PUT and DELETE

```python
@app.route("/students/<int:student_id>", methods=["PUT", "DELETE"])
def modify_student(student_id):
    student = next((s for s in students if s["id"] == student_id), None)
    if student is None:
        return jsonify({"error": "Student not found"}), 404

    if request.method == "PUT":
        updates = request.get_json()
        student.update(updates)
        return jsonify(student)

    if request.method == "DELETE":
        students.remove(student)
        return jsonify({"message": "Student deleted"})
```

### Testing Your API From Python

Once your Flask server is running in one terminal, you can talk to it from another script, just like you did with real APIs:

```python
import requests

response = requests.get("http://127.0.0.1:5000/students")
print(response.json())

new_student = {"name": "Sam", "grade": 7}
response = requests.post("http://127.0.0.1:5000/students", json=new_student)
print(response.status_code)   # 201
print(response.json())
```

### Putting It All Together: A Mini Student API

Combine everything above into one `app.py`: a `students` list as your data, a `GET`/`POST` route for `/students`, and a `GET`/`PUT`/`DELETE` route for `/students/<int:student_id>`. This single file is a real, working REST API — the same basic shape used by huge, professional production systems, just smaller.

### Why This Matters

Every app you have used that saves data to the cloud — games with leaderboards, messaging apps, social media — has a server somewhere built using ideas just like these (often not Flask exactly, but the same core concepts of routes, methods, and JSON responses). You have now built both sides of the client-server relationship.

### Key Takeaways

- Flask is a Python framework for building web applications and APIs using simple route functions.
- `@app.route("/path")` defines what happens when someone visits that URL; `methods=["GET", "POST"]` controls which HTTP methods are allowed.
- `jsonify()` converts Python data into a proper JSON HTTP response.
- `request.get_json()` reads the JSON body sent with a POST or PUT request.
- Returning a tuple like `jsonify(data), 201` lets you set a custom status code alongside your response.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l79', 'Intro to SQL and Databases (SELECT, INSERT, WHERE)', 'developers', 'Databases', 'en', 'intermediate', 35, 150, 79, '## Intro to SQL and Databases

You used SQLite from inside Python a few lessons ago, sending SQL commands through `cursor.execute()`. Today you will slow down and focus on **SQL** itself — the language of databases — so you deeply understand the commands you have already been using, and can write more powerful ones.

### What Is SQL?

SQL (Structured Query Language) is a language designed specifically for working with data stored in tables. It is used by nearly every database system in the world — SQLite, PostgreSQL (which this very platform uses!), MySQL, and more. Learning SQL is one of the most universally useful skills in software development.

### Tables, Rows, and Columns

A SQL table looks like a spreadsheet:

```
students table:

| id | name  | age | grade |
|----|-------|-----|-------|
| 1  | Amir  | 13  | 8     |
| 2  | Lina  | 12  | 7     |
| 3  | Theo  | 14  | 8     |
```

Each row is one record (one student). Each column is one piece of information about that record (name, age, grade).

### CREATE TABLE: Defining a Table''s Structure

```sql
CREATE TABLE students (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER,
    grade INTEGER
);
```

This defines the shape of the data before anything is stored.

### INSERT: Adding Data

```sql
INSERT INTO students (name, age, grade) VALUES ("Amir", 13, 8);
INSERT INTO students (name, age, grade) VALUES ("Lina", 12, 7);
INSERT INTO students (name, age, grade) VALUES ("Theo", 14, 8);
```

Each `INSERT` adds one new row to the table.

### SELECT: Reading Data

`SELECT` is the most common SQL command — it retrieves data from a table.

```sql
SELECT * FROM students;
```

The `*` means "every column." This returns all rows, with all their columns.

To get only specific columns:

```sql
SELECT name, grade FROM students;
```

```
| name  | grade |
|-------|-------|
| Amir  | 8     |
| Lina  | 7     |
| Theo  | 8     |
```

### WHERE: Filtering Rows

`WHERE` narrows down which rows are returned, based on a condition:

```sql
SELECT * FROM students WHERE grade = 8;
```

```
| id | name  | age | grade |
|----|-------|-----|-------|
| 1  | Amir  | 13  | 8     |
| 3  | Theo  | 14  | 8     |
```

You can use comparison operators just like in Python:

```sql
SELECT * FROM students WHERE age > 12;
SELECT * FROM students WHERE age >= 13 AND grade = 8;
SELECT * FROM students WHERE name != "Lina";
SELECT * FROM students WHERE name LIKE "A%";   -- starts with "A"
```

`AND`/`OR` combine multiple conditions, just like Python''s `and`/`or`. `LIKE` with a `%` wildcard matches text patterns.

### ORDER BY: Sorting Results

```sql
SELECT * FROM students ORDER BY age;            -- smallest to largest
SELECT * FROM students ORDER BY age DESC;        -- largest to smallest
```

### UPDATE: Changing Existing Data

```sql
UPDATE students SET grade = 9 WHERE name = "Amir";
```

This changes Amir''s grade to 9. Be careful: if you forget the `WHERE` clause, **every row** gets updated!

### DELETE: Removing Data

```sql
DELETE FROM students WHERE name = "Theo";
```

Just like `UPDATE`, forgetting `WHERE` here would delete **every row** in the table — always double check before running a `DELETE`.

### Using SQL From Python (A Quick Reminder)

You already saw this pattern in the SQLite lesson — now you understand the SQL itself much more deeply:

```python
import sqlite3

connection = sqlite3.connect("school.db")
cursor = connection.cursor()

cursor.execute("SELECT * FROM students WHERE grade = ?", (8,))
results = cursor.fetchall()
for row in results:
    print(row)

connection.close()
```

### A Practical Example: Querying for a Report

```sql
-- Find all students aged 13 or older, sorted by name
SELECT name, age, grade
FROM students
WHERE age >= 13
ORDER BY name;
```

```sql
-- Count how many students are in grade 8
SELECT COUNT(*) FROM students WHERE grade = 8;
```

`COUNT(*)` is one of several built-in SQL functions for summarizing data — others include `AVG()`, `SUM()`, `MIN()`, and `MAX()`.

```sql
SELECT AVG(age) FROM students;
SELECT MAX(grade) FROM students;
```

### Why SQL Matters

Almost every application that stores meaningful amounts of data — social media platforms, banking apps, school grading systems, even this very curriculum platform — uses a SQL database behind the scenes. The four commands you learned today — `SELECT`, `INSERT`, `UPDATE`, `DELETE` — paired with `WHERE` for filtering, are the core of working with virtually any relational database you will ever encounter.

### Key Takeaways

- SQL is the standard language for creating, reading, updating, and deleting data in a relational database.
- `SELECT` retrieves data, `INSERT` adds it, `UPDATE` changes it, and `DELETE` removes it.
- `WHERE` filters which rows a command affects — always double-check it before running `UPDATE` or `DELETE`.
- `ORDER BY` sorts results, and functions like `COUNT()`, `AVG()`, and `MAX()` summarize data.
- These same SQL fundamentals apply across nearly every database system you will use in your programming career, from SQLite to large production databases.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;
