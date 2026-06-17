-- =============================================================================
-- CODEship Academy — Developers Lessons l80–l99 (Final Stretch + Capstone)
-- =============================================================================

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l80', 'SQL Joins and Table Relationships', 'developers', 'Databases', 'en', 'advanced', 35, 150, 80, '## SQL Joins and Table Relationships

In the last lesson you learned how to store data in tables and query a single table with `SELECT`. But real-world data almost never lives in just one table. A school database might have a `students` table, a `classes` table, and an `enrollments` table that connects them. To get useful answers — like "which students are in Ms. Patel''s class?" — you need to combine, or **join**, multiple tables together.

### Why split data into multiple tables?

Imagine one giant table with every student''s name, grade, AND every class they''ve ever taken, repeated on every row. That wastes space and makes updates error-prone. Instead, relational databases split data into focused tables and link them with **keys**:

- A **primary key** uniquely identifies a row in a table (e.g. `student_id`).
- A **foreign key** is a column in one table that refers to the primary key of another table, creating a relationship.

```sql
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    name TEXT NOT NULL
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    class_name TEXT NOT NULL,
    teacher TEXT
);

CREATE TABLE enrollments (
    student_id INTEGER REFERENCES students(student_id),
    class_id INTEGER REFERENCES classes(class_id)
);
```

Here, `enrollments` is a "join table" — it doesn''t describe a student or a class on its own, it just records which students belong to which classes. This is called a **many-to-many relationship**: one student can be in many classes, and one class can have many students.

### INNER JOIN: matching rows from both tables

The most common join is `INNER JOIN`, which returns only the rows where there''s a match in both tables.

```sql
SELECT students.name, classes.class_name
FROM students
INNER JOIN enrollments ON students.student_id = enrollments.student_id
INNER JOIN classes ON enrollments.class_id = classes.class_id
WHERE classes.teacher = ''Ms. Patel'';
```

This query walks across all three tables: it starts with `students`, uses `enrollments` to figure out which classes each student is in, and uses `classes` to filter down to only Ms. Patel''s class.

### LEFT JOIN: keep everything from the left table

Sometimes you want all rows from one table even if there''s no match in the other. A `LEFT JOIN` keeps every row from the "left" table and fills in `NULL` for any columns from the right table that don''t have a match.

```sql
SELECT students.name, classes.class_name
FROM students
LEFT JOIN enrollments ON students.student_id = enrollments.student_id
LEFT JOIN classes ON enrollments.class_id = classes.class_id;
```

This is great for finding students who aren''t enrolled in anything yet — their `class_name` will simply show up as `NULL` instead of them disappearing from the results entirely.

### One-to-many relationships

Not every relationship needs a separate join table. If each class has exactly one teacher, and a teacher can teach many classes, that''s a **one-to-many relationship**, and you can just put a foreign key directly on the "many" side:

```sql
CREATE TABLE teachers (
    teacher_id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE classes (
    class_id INTEGER PRIMARY KEY,
    class_name TEXT,
    teacher_id INTEGER REFERENCES teachers(teacher_id)
);

SELECT classes.class_name, teachers.name AS teacher_name
FROM classes
INNER JOIN teachers ON classes.teacher_id = teachers.teacher_id;
```

### Try it yourself

1. Sketch out two tables for a "library" database: `books` and `borrowers`. What key links them?
2. Write a join that lists every book and the name of the person currently borrowing it (if any) — think about whether you need an `INNER JOIN` or a `LEFT JOIN`.
3. Add a `genres` table and a join table `book_genres` to support a many-to-many relationship between books and genres.

### Key Takeaways
- Relational databases split data into multiple tables to avoid duplication and keep data consistent.
- A **primary key** uniquely identifies rows in a table; a **foreign key** links rows in one table to rows in another.
- `INNER JOIN` returns only rows that match in both tables.
- `LEFT JOIN` keeps all rows from the left table, even when there''s no matching row on the right.
- Many-to-many relationships usually require a separate join table connecting two foreign keys.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l81', 'Intro to Web Security: XSS and SQL Injection Basics', 'developers', 'Web Security', 'en', 'advanced', 35, 150, 81, '## Intro to Web Security: XSS and SQL Injection Basics

Every time a website lets users type something — a comment, a search box, a login form — it opens a door. Most people who walk through that door just want to use the app normally. But some try to trick the app into doing something it shouldn''t. Today you''ll learn about two of the most common and historically damaging web vulnerabilities: **XSS** and **SQL injection** — and how developers defend against them.

### What is XSS (Cross-Site Scripting)?

XSS happens when an attacker manages to inject their own JavaScript into a page that other users will view. If a website takes user input and displays it back without checking it carefully, that input might not be plain text — it might be code.

Imagine a comment box on a blog that does this:

```javascript
// DANGEROUS: directly inserting user input as HTML
const commentText = getUserComment();
document.getElementById("comments").innerHTML += `<p>${commentText}</p>`;
```

If a user submits a comment like this instead of a normal sentence...

```html
<script>alert("I can run code in your browser!")</script>
```

...that script actually executes in the browser of everyone who views the page! A real attacker wouldn''t just pop up an alert — they could steal cookies, session tokens, or redirect users to a fake login page.

### Defending against XSS

The fix is to never trust raw user input as HTML. Instead, **escape** it so that special characters like `<` and `>` are displayed as text, not interpreted as tags.

```javascript
// SAFER: use textContent instead of innerHTML
const commentParagraph = document.createElement("p");
commentParagraph.textContent = commentText; // treated as plain text, not HTML
document.getElementById("comments").appendChild(commentParagraph);
```

Most modern frameworks (React, Vue, etc.) automatically escape content for you when you render variables, which is one reason they''ve become so popular — but you still need to be careful with anything that explicitly says "raw HTML" or `dangerouslySetInnerHTML`.

### What is SQL Injection?

SQL injection is a similar idea, but it targets your database instead of other users'' browsers. It happens when user input gets pasted directly into a SQL query string.

```javascript
// DANGEROUS: building a query with string concatenation
const username = getUserInput(); // imagine the user types: anything'' OR ''1''=''1
const query = `SELECT * FROM users WHERE username = ''${username}''`;
```

If the attacker types `anything'' OR ''1''=''1` as their username, the final query becomes:

```sql
SELECT * FROM users WHERE username = ''anything'' OR ''1''=''1''
```

Since `''1''=''1''` is always true, this query returns EVERY row in the `users` table — potentially leaking every user''s data, or letting an attacker log in without knowing a real password.

### Defending against SQL Injection: Parameterized Queries

The fix is to never build SQL queries by concatenating strings with user input. Instead, use **parameterized queries** (also called prepared statements), where the database treats user input strictly as data, never as code.

```javascript
// SAFER: using a parameterized query
const username = getUserInput();
db.query("SELECT * FROM users WHERE username = $1", [username]);
```

Here, even if the attacker types `anything'' OR ''1''=''1`, the database treats the whole string as a literal username to search for — it will simply find no matching user, instead of running malicious logic.

### A simple rule to remember

> Never trust user input. Always escape it before displaying it as HTML, and always parameterize it before using it in a database query.

### Try it yourself

1. Find a "guestbook" or comment example online (in a safe sandbox) and identify whether it escapes user input.
2. Rewrite the dangerous JavaScript snippet above using `textContent` so it''s XSS-safe.
3. Rewrite the dangerous SQL query above using a parameterized query in a language of your choice.

### Key Takeaways
- **XSS (Cross-Site Scripting)** lets attackers inject malicious JavaScript into pages viewed by other users.
- Defend against XSS by escaping user input (use `textContent`, not raw `innerHTML`) before displaying it.
- **SQL Injection** lets attackers manipulate your database queries by injecting SQL through user input fields.
- Defend against SQL Injection with **parameterized queries**, never by concatenating user input directly into SQL strings.
- The golden rule of web security: never trust user input — always validate, escape, or parameterize it.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l82', 'Debugging Strategies and Using DevTools', 'developers', 'Best Practices', 'en', 'advanced', 35, 150, 82, '## Debugging Strategies and Using DevTools

Every developer, no matter how experienced, spends a huge chunk of their time debugging — finding and fixing problems in code that isn''t working the way it should. The difference between a frustrated beginner and a confident developer often isn''t how many bugs they hit, it''s how systematically they hunt them down. Today we''ll build a debugging toolkit.

### Step 1: Reproduce the bug reliably

Before you can fix a bug, you need to be able to make it happen on demand. "It sometimes crashes" is much harder to fix than "it crashes every time I click submit with an empty name field." Try to find the exact, repeatable steps that trigger the problem.

### Step 2: Read the error message carefully

New developers often skim past error messages because they look scary. But error messages are usually trying to help you! They typically include:

- The **type** of error (e.g. `TypeError`, `ReferenceError`)
- A **message** describing what went wrong
- A **stack trace** showing exactly which line of code caused it

```javascript
function getFirstLetter(name) {
    return name[0].toUpperCase();
}

getFirstLetter(undefined);
// TypeError: Cannot read properties of undefined (reading ''0'')
//     at getFirstLetter (app.js:2:12)
```

This tells us exactly where to look: line 2, where we tried to access `name[0]` but `name` was `undefined`.

### Step 3: Use console.log strategically

The simplest and most powerful debugging tool is printing values to see what''s actually happening, instead of guessing.

```javascript
function calculateTotal(cart) {
    console.log("cart received:", cart);
    let total = 0;
    for (const item of cart) {
        console.log("adding item:", item.name, item.price);
        total += item.price;
    }
    console.log("final total:", total);
    return total;
}
```

By printing values at each step, you can see exactly where the numbers stop matching your expectations — that''s usually right where the bug lives.

### Step 4: Use your browser''s DevTools

Every modern browser includes built-in Developer Tools (open with F12 or right-click → Inspect). The most useful panels for debugging are:

- **Console** — view `console.log` output and JavaScript errors, and run code interactively.
- **Elements** — inspect and live-edit the HTML/CSS of the page to see what''s actually rendered.
- **Sources** — set **breakpoints** that pause your code mid-execution so you can inspect variables.
- **Network** — see every request your page makes, including failed API calls and their responses.

### Setting a breakpoint

Instead of sprinkling `console.log` everywhere, you can pause execution entirely and explore:

```javascript
function calculateTotal(cart) {
    debugger; // execution pauses here when DevTools is open
    let total = 0;
    for (const item of cart) {
        total += item.price;
    }
    return total;
}
```

When the browser hits the `debugger` statement, it freezes the page and lets you step through code line by line in the Sources panel, watching every variable change in real time.

### Step 5: Isolate the problem

If a bug is hard to find, try cutting the problem in half. Comment out chunks of code, or write a tiny standalone test case with the smallest possible example that still reproduces the bug. This technique is sometimes called a "binary search for bugs."

### Step 6: Check your assumptions

A huge number of bugs come from an assumption that turns out to be false — "this list will never be empty," "this function always returns a number." When stuck, list out your assumptions and verify each one with a `console.log` or breakpoint.

### Try it yourself

1. Open DevTools on any website and explore the Console, Elements, and Network tabs.
2. Take a piece of broken code, add `console.log` statements at 3 different points, and use the output to find the bug.
3. Practice setting a `debugger` statement in a function and stepping through it line by line.

### Key Takeaways
- First reproduce the bug reliably — a bug you can''t trigger on demand is very hard to fix.
- Read error messages and stack traces carefully; they usually point straight at the problem.
- `console.log` lets you check your assumptions about what values actually are at runtime.
- Browser DevTools (Console, Elements, Sources, Network) are essential tools for inspecting and pausing running code.
- Breakpoints (via `debugger` or clicking in the Sources panel) let you pause and step through code line by line.
- When stuck, isolate the smallest piece of code that reproduces the bug.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l83', 'Intro to Algorithms: Big-O Notation (Time Complexity)', 'developers', 'Computer Science', 'en', 'advanced', 35, 150, 83, '## Intro to Algorithms: Big-O Notation (Time Complexity)

When you write code, there''s usually more than one way to solve a problem. But some solutions are much faster than others — especially as the amount of data grows. **Big-O notation** is the language computer scientists use to describe how an algorithm''s running time grows as its input gets bigger.

### Why does this matter?

A search function that works fine on 10 items might take forever on 10 million items, depending on HOW it searches. Big-O lets us compare algorithms without needing to run them, just by reasoning about their structure.

### O(1): Constant time

An O(1) algorithm takes the same amount of time no matter how big the input is.

```javascript
function getFirstItem(list) {
    return list[0]; // always exactly one step, no matter the list size
}
```

Whether `list` has 5 items or 5 million, grabbing the first one takes the same single step.

### O(n): Linear time

An O(n) algorithm''s running time grows directly in proportion to the input size `n`. If you double the input, you roughly double the work.

```javascript
function containsValue(list, target) {
    for (const item of list) {       // checks every item, one at a time
        if (item === target) {
            return true;
        }
    }
    return false;
}
```

In the worst case (the target isn''t in the list, or it''s the very last item), this loop runs once for every item — so a list of 1,000 items takes 1,000 checks, and a list of 1,000,000 items takes 1,000,000 checks.

### O(n²): Quadratic time

An O(n²) algorithm''s running time grows with the SQUARE of the input size. This often happens with nested loops, where for every item, you loop through all the items again.

```python
def has_duplicate(items):
    for i in range(len(items)):
        for j in range(len(items)):
            if i != j and items[i] == items[j]:
                return True
    return False
```

For a list of 10 items, this checks roughly 100 pairs. For a list of 1,000 items, it checks roughly 1,000,000 pairs! Quadratic algorithms get slow VERY quickly as data grows.

### O(log n): Logarithmic time

An O(log n) algorithm gets only slightly slower as the input grows, because it repeatedly cuts the problem in half. **Binary search** is the classic example — but it only works on already-sorted data.

```python
def binary_search(sorted_list, target):
    low, high = 0, len(sorted_list) - 1
    while low <= high:
        mid = (low + high) // 2
        if sorted_list[mid] == target:
            return mid
        elif sorted_list[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1
```

Each step throws away HALF of the remaining possibilities. Searching a sorted list of 1,000,000 items takes at most about 20 steps — compare that to a linear search, which could take up to 1,000,000 steps!

### Comparing growth rates

| Input size (n) | O(1) | O(log n) | O(n) | O(n²) |
|---|---|---|---|---|
| 10 | 1 | ~3 | 10 | 100 |
| 1,000 | 1 | ~10 | 1,000 | 1,000,000 |
| 1,000,000 | 1 | ~20 | 1,000,000 | 1,000,000,000,000 |

Notice how O(n²) explodes compared to everything else — this is why nested loops over large datasets are often a red flag for performance.

### Big-O ignores constants and focuses on the worst case

Big-O describes the SHAPE of growth, not exact timing. We typically care about the **worst-case** scenario, since that''s our guarantee about how slow the algorithm could possibly be.

### Try it yourself

1. Classify each of these by Big-O: printing every item in a list once; checking if a number is even; comparing every pair of students in a class for matching birthdays.
2. Rewrite the `has_duplicate` function above using a Set to bring it down to O(n) time. (Hint: a Set lookup is O(1)!)
3. Explain in your own words why binary search requires the list to already be sorted.

### Key Takeaways
- Big-O notation describes how an algorithm''s running time grows as the input size grows.
- O(1) constant time: same speed regardless of input size.
- O(n) linear time: speed grows directly with input size.
- O(n²) quadratic time: speed grows with the square of input size — often caused by nested loops.
- O(log n) logarithmic time: speed grows very slowly because the problem is repeatedly cut in half (e.g. binary search).
- We usually focus on worst-case behavior so we can guarantee an upper bound on how slow an algorithm could be.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l84', 'Data Structures: Stacks and Queues', 'developers', 'Data Structures', 'en', 'advanced', 35, 150, 84, '## Data Structures: Stacks and Queues

So far you''ve mostly stored collections of data in arrays/lists. But there are specialized data structures that restrict HOW you can add and remove items — and that restriction is exactly what makes them useful. Today: **stacks** and **queues**.

### Stacks: Last In, First Out (LIFO)

Picture a stack of plates. You can only add a new plate to the TOP, and you can only remove the plate that''s currently on TOP. The first plate you put down is the last one you''ll ever take off. This is called **LIFO**: Last In, First Out.

A stack supports two main operations:
- **push** — add an item to the top
- **pop** — remove and return the item from the top

```javascript
class Stack {
    constructor() {
        this.items = [];
    }
    push(item) {
        this.items.push(item);
    }
    pop() {
        return this.items.pop();
    }
    peek() {
        return this.items[this.items.length - 1];
    }
    isEmpty() {
        return this.items.length === 0;
    }
}

const undoStack = new Stack();
undoStack.push("typed ''hello''");
undoStack.push("typed '' world''");
undoStack.push("deleted ''world''");
console.log(undoStack.pop()); // "deleted ''world''" — the most recent action
```

Stacks are perfect for **undo features**, the back button in your browser history, and tracking function calls (the "call stack" you''ve seen in error messages is a literal stack!).

### Queues: First In, First Out (FIFO)

Now picture a checkout line at a store. The first person to join the line is the first person served. New people join at the BACK, and people leave from the FRONT. This is called **FIFO**: First In, First Out.

A queue supports two main operations:
- **enqueue** — add an item to the back
- **dequeue** — remove and return the item from the front

```python
class Queue:
    def __init__(self):
        self.items = []

    def enqueue(self, item):
        self.items.append(item)

    def dequeue(self):
        return self.items.pop(0)

    def is_empty(self):
        return len(self.items) == 0

print_queue = Queue()
print_queue.enqueue("essay.pdf")
print_queue.enqueue("photo.png")
print_queue.enqueue("homework.docx")
print(print_queue.dequeue())  # "essay.pdf" — first one submitted, first one printed
```

Queues are perfect for **task scheduling**, printer queues, handling requests on a web server in the order they arrive, and breadth-first search in graphs/trees (which you''ll see in upcoming lessons).

### Comparing stacks and queues

| | Add | Remove | Real-world example |
|---|---|---|---|
| Stack (LIFO) | push (top) | pop (top) | Undo history, browser back button |
| Queue (FIFO) | enqueue (back) | dequeue (front) | Checkout line, print queue |

### Why use a restricted structure at all?

You might wonder: why not just use a regular array and do whatever you want? The answer is that restricting how data flows in and out makes your code''s INTENT clear, and prevents accidental bugs — if you label something a Queue, anyone reading your code immediately knows tasks are processed in arrival order, no need to check.

### Try it yourself

1. Use the `Stack` class above to check whether a string of parentheses like `"(()())"` is balanced — push `(` and pop when you see `)`.
2. Use the `Queue` class above to simulate a customer service line, printing out the order customers get served.
3. Implement a `peek` method for the `Queue` class that returns the front item without removing it.

### Key Takeaways
- A **stack** is LIFO (Last In, First Out) — items are added and removed from the same end (the top).
- A **queue** is FIFO (First In, First Out) — items are added at the back and removed from the front.
- Stacks are used for undo features, browser history, and function call tracking.
- Queues are used for task scheduling, print queues, and processing requests in arrival order.
- Choosing the right restricted structure makes code intent clearer and prevents bugs from out-of-order processing.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l85', 'Data Structures: Linked Lists', 'developers', 'Data Structures', 'en', 'advanced', 35, 150, 85, '## Data Structures: Linked Lists

Arrays are great, but they have a hidden cost: inserting or removing an item from the MIDDLE of an array means shifting every item after it. A **linked list** solves this by giving up one thing (instant access to any item by index) in exchange for cheap insertion and removal anywhere in the list.

### What is a linked list?

Instead of storing items next to each other in memory like an array does, a linked list stores each item in its own **node**. Each node holds a value AND a pointer (reference) to the NEXT node in the list.

```
[ "apple" | next ] --> [ "banana" | next ] --> [ "cherry" | next ] --> null
```

The list itself just needs to remember where the FIRST node (the **head**) is — everything else is reachable by following the chain of `next` pointers.

### Building a simple linked list

```javascript
class Node {
    constructor(value) {
        this.value = value;
        this.next = null;
    }
}

class LinkedList {
    constructor() {
        this.head = null;
    }

    addToFront(value) {
        const newNode = new Node(value);
        newNode.next = this.head;
        this.head = newNode;
    }

    print() {
        let current = this.head;
        const values = [];
        while (current !== null) {
            values.push(current.value);
            current = current.next;
        }
        console.log(values.join(" -> "));
    }
}

const fruits = new LinkedList();
fruits.addToFront("cherry");
fruits.addToFront("banana");
fruits.addToFront("apple");
fruits.print(); // apple -> banana -> cherry
```

Notice `addToFront` doesn''t need to shift anything — it just creates one new node and updates two pointers. That''s O(1), compared to an array''s `unshift()`, which is O(n) because every existing item has to move over.

### Inserting in the middle

```python
class Node:
    def __init__(self, value):
        self.value = value
        self.next = None

def insert_after(node, value):
    new_node = Node(value)
    new_node.next = node.next
    node.next = new_node
```

To insert a new node after an existing one, you only touch TWO pointers — no shifting required, no matter how long the list is. This is the main advantage of linked lists over arrays.

### The trade-off: no random access

The downside is that to reach the 100th item, you must start at the head and follow `next` pointers 100 times — there''s no way to "jump" directly to index 100 like `array[100]`. This makes lookups O(n), where arrays give you O(1) lookups by index.

### When to use a linked list vs. an array

| | Array | Linked List |
|---|---|---|
| Access by index | O(1) — instant | O(n) — must walk the chain |
| Insert/remove at front | O(n) — must shift | O(1) — just update pointers |
| Memory layout | Contiguous block | Scattered nodes |

Linked lists shine when you''re constantly adding/removing from the ends or middle, and rarely need to jump to a specific position — like implementing the Undo stack from the last lesson, or a music player''s "up next" queue.

### Try it yourself

1. Add a `removeFromFront()` method to the `LinkedList` class that returns and removes the head node''s value.
2. Write a function `findValue(list, target)` that walks the chain and returns `true` if `target` is found anywhere in the list.
3. Challenge: implement a `size()` method that counts how many nodes are in the list without using an extra counter variable stored on the list itself.

### Key Takeaways
- A linked list stores items in nodes, where each node points to the next one in the chain.
- The list only needs to track the **head** (first node) — the rest is reachable by following `next` pointers.
- Inserting or removing nodes is O(1) once you have a reference to the right spot, since no shifting is required.
- Accessing an item by position is O(n), unlike an array''s O(1) index access — this is the key trade-off.
- Choose linked lists when you frequently insert/remove at the ends or middle; choose arrays when you need fast random access.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l86', 'Data Structures: Trees (Introduction)', 'developers', 'Data Structures', 'en', 'advanced', 35, 150, 86, '## Data Structures: Trees (Introduction)

Linked lists chain items one after another, but lots of real-world data is naturally hierarchical, not linear — think of a family tree, a file system with folders inside folders, or how HTML elements nest inside each other. For that, we use a **tree**.

### What is a tree?

A tree is built from **nodes**, just like a linked list, but instead of each node pointing to ONE next node, each node can point to MULTIPLE **children**.

```
          root
         /    \
     left      right
     /  \      /   \
   ...  ...  ...   ...
```

Some vocabulary you''ll need:
- **Root** — the top node of the tree (it has no parent).
- **Parent / Child** — a node directly connected below another is its child; the node above is its parent.
- **Leaf** — a node with no children.
- **Depth** — how many steps a node is from the root.

### Building a simple tree

A **binary tree** is the most common kind — every node has AT MOST two children, usually called `left` and `right`.

```javascript
class TreeNode {
    constructor(value) {
        this.value = value;
        this.left = null;
        this.right = null;
    }
}

const root = new TreeNode(50);
root.left = new TreeNode(30);
root.right = new TreeNode(70);
root.left.left = new TreeNode(20);
root.left.right = new TreeNode(40);
```

This creates a small tree with `50` at the root, `30` and `70` as its children, and `20`/`40` as `30`''s children.

### Binary Search Trees (BSTs)

A **Binary Search Tree** is a binary tree with a special rule: for every node, everything in its LEFT subtree is smaller, and everything in its RIGHT subtree is larger. This rule makes searching extremely fast.

```python
class TreeNode:
    def __init__(self, value):
        self.value = value
        self.left = None
        self.right = None

def insert(node, value):
    if node is None:
        return TreeNode(value)
    if value < node.value:
        node.left = insert(node.left, value)
    else:
        node.right = insert(node.right, value)
    return node

def contains(node, target):
    if node is None:
        return False
    if node.value == target:
        return True
    elif target < node.value:
        return contains(node.left, target)
    else:
        return contains(node.right, target)
```

Because of the ordering rule, `contains` can skip checking half the remaining tree at every step — just like binary search on a sorted array! A balanced BST gives you O(log n) search, insert, and delete.

### Traversing a tree

Sometimes you need to visit every node. The three classic ways to walk a binary tree are usually done recursively:

```javascript
function inOrderTraversal(node, results = []) {
    if (node === null) return results;
    inOrderTraversal(node.left, results);
    results.push(node.value);
    inOrderTraversal(node.right, results);
    return results;
}
// For a Binary Search Tree, in-order traversal visits values from smallest to largest!
```

`inOrderTraversal` on our BST example would visit nodes in increasing numeric order — that''s a handy side effect of the BST ordering rule.

### Real-world trees you already use

- **File systems**: folders contain files and other folders, forming a tree.
- **The DOM**: every webpage is a tree of HTML elements nested inside each other.
- **Decision trees**: used in games and AI to represent a sequence of choices.

### Try it yourself

1. Draw a binary search tree by inserting these numbers in order: 50, 25, 75, 10, 30, 60, 90.
2. Trace through `contains(root, 30)` on your tree above — how many comparisons does it take versus checking every node one by one?
3. Write a `countNodes(node)` function that recursively counts how many nodes are in a tree.

### Key Takeaways
- A tree is made of nodes where each node can have multiple children, forming a hierarchy with one root.
- A **binary tree** restricts each node to at most two children, typically called `left` and `right`.
- A **Binary Search Tree (BST)** keeps smaller values to the left and larger values to the right, enabling O(log n) search.
- Tree **traversal** (like in-order traversal) lets you visit every node in a specific, predictable order.
- Trees model hierarchical real-world data: file systems, the HTML DOM, organization charts, and more.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l87', 'Intro to Object-Oriented Design Patterns', 'developers', 'Computer Science', 'en', 'advanced', 35, 150, 87, '## Intro to Object-Oriented Design Patterns

You''ve already learned about classes and objects. But as programs grow bigger, certain PROBLEMS keep showing up again and again — and over decades, developers have discovered reusable solutions to them, called **design patterns**. Today we''ll explore three classic, beginner-friendly patterns.

### What is a design pattern?

A design pattern is not a finished piece of code you copy and paste — it''s a reusable TEMPLATE for solving a common design problem, like "how do I make sure only one object of this type ever exists?" or "how do I let one object notify others when something happens?"

### Pattern 1: Singleton

Sometimes you want EXACTLY ONE instance of a class to exist in your whole program — like a single shared configuration object or a single connection to a game''s sound system. The **Singleton pattern** ensures this.

```javascript
class GameSettings {
    static #instance = null;

    constructor() {
        if (GameSettings.#instance) {
            throw new Error("Use GameSettings.getInstance() instead!");
        }
        this.volume = 50;
        this.difficulty = "normal";
    }

    static getInstance() {
        if (!GameSettings.#instance) {
            GameSettings.#instance = new GameSettings();
        }
        return GameSettings.#instance;
    }
}

const settingsA = GameSettings.getInstance();
const settingsB = GameSettings.getInstance();
settingsA.volume = 80;
console.log(settingsB.volume); // 80 — they''re literally the same object!
```

No matter how many times you call `getInstance()`, you always get back the SAME object — useful for things that should never have duplicates floating around.

### Pattern 2: Factory

Sometimes the exact type of object you need to create depends on some condition, and you don''t want that decision logic scattered everywhere. The **Factory pattern** centralizes object creation in one place.

```python
class Cat:
    def speak(self):
        return "Meow!"

class Dog:
    def speak(self):
        return "Woof!"

def animal_factory(kind):
    if kind == "cat":
        return Cat()
    elif kind == "dog":
        return Dog()
    else:
        raise ValueError(f"Unknown animal kind: {kind}")

pet = animal_factory("dog")
print(pet.speak())  # Woof!
```

If you later add a `Bird` class, you only need to update the factory function — every place in your code that calls `animal_factory` keeps working unchanged.

### Pattern 3: Observer

The **Observer pattern** lets one object (the "subject") notify a list of other objects (the "observers") whenever something happens, without the subject needing to know any details about who''s listening. You''ve actually already used this pattern every time you''ve called `addEventListener` in JavaScript!

```javascript
class ScoreBoard {
    constructor() {
        this.listeners = [];
    }

    onScoreChange(callback) {
        this.listeners.push(callback);
    }

    setScore(newScore) {
        this.score = newScore;
        for (const callback of this.listeners) {
            callback(newScore); // notify every observer
        }
    }
}

const board = new ScoreBoard();
board.onScoreChange((score) => console.log(`UI updated: score is now ${score}`));
board.onScoreChange((score) => console.log(`Sound effect played for score ${score}`));

board.setScore(10);
// UI updated: score is now 10
// Sound effect played for score 10
```

Both listeners run automatically whenever `setScore` is called — the `ScoreBoard` doesn''t need to know what each listener actually does.

### Why bother with named patterns at all?

Once you know these patterns, they become a shared VOCABULARY. Instead of explaining your whole design to a teammate, you can just say "I used a Factory here" and they immediately understand the shape of your code.

### Try it yourself

1. Modify the `animal_factory` function to support a new `"bird"` kind that returns a `Bird` class with its own `speak()` method.
2. Add a third listener to the `ScoreBoard` example that logs a special message when the score crosses 100.
3. Think of a real app feature (like notifications, or a shared settings menu) and identify which pattern above would fit it best.

### Key Takeaways
- Design patterns are reusable TEMPLATES for solving common software design problems, not literal code to copy.
- The **Singleton** pattern guarantees only one instance of a class ever exists.
- The **Factory** pattern centralizes object creation logic so the rest of your code doesn''t need to know creation details.
- The **Observer** pattern lets a subject notify many listeners about changes without depending on their details — used constantly in event-driven code.
- Knowing pattern names gives developers a shared vocabulary for describing designs quickly.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l88', 'Version Control Workflows: Branches, Pull Requests, Code Review', 'developers', 'Best Practices', 'en', 'advanced', 35, 150, 88, '## Version Control Workflows: Branches, Pull Requests, Code Review

You''ve used Git to save versions of your own projects before. But real software teams almost never let everyone edit the same code at the same time directly. Instead, they use **branches**, **pull requests**, and **code review** to collaborate safely. Today you''ll learn the workflow professional developers use every single day.

### Why not just edit the main code directly?

If five developers all edited the same files in the same place at the same time, they''d constantly overwrite each other''s work, and broken or half-finished code could end up live for users. Git solves this with **branches**: independent copies of the codebase where you can experiment freely.

### Creating and using a branch

```bash
# See what branch you''re currently on
git branch

# Create a new branch for your feature, and switch to it
git checkout -b add-dark-mode

# Make changes, then stage and commit them as usual
git add styles.css
git commit -m "Add dark mode toggle to settings page"

# Push your new branch up to the remote repository
git push origin add-dark-mode
```

The `main` branch stays untouched and stable while you work on `add-dark-mode` — if your feature breaks something, it only breaks your branch, not the whole team''s code.

### Pull Requests: proposing your changes

Once your feature is ready, you open a **Pull Request** (PR) — sometimes called a "merge request." A PR is a formal proposal: "Here''s the code I wrote on my branch — please review it, then merge it into `main`."

A good pull request includes:
- A clear **title** summarizing the change
- A **description** explaining WHY the change was made, not just what changed
- Links to any related task or issue
- Screenshots, if the change affects something visual

```text
Title: Add dark mode toggle to settings page

Description:
Several users requested a dark mode option (see issue #42).
This PR adds a toggle switch in Settings that saves the user''s
preference to local storage and applies a `dark-theme` class to
the body element.

Tested manually on Chrome and Firefox.
```

### Code Review: a second pair of eyes

Before a PR gets merged, at least one other developer reviews it. Reviewers look for bugs, unclear code, missed edge cases, and whether the change follows the team''s conventions. Reviewers can leave **comments** directly on specific lines of code.

```text
Reviewer comment on line 24:
"Should we also reset the toggle if the user clears their
browser storage? Right now it might get stuck showing
the wrong state."
```

The original author can reply, make changes, and push new commits to the SAME branch — the pull request automatically updates with the new commits, no need to open a new one.

### Resolving merge conflicts

If `main` has changed since you started your branch, Git might not be able to automatically combine the two versions of a file. This is called a **merge conflict**, and Git will mark exactly where the disagreement is:

```text
<<<<<<< HEAD
const greeting = "Welcome back!";
=======
const greeting = "Hello again!";
>>>>>>> add-dark-mode
```

You manually choose which version to keep (or write a new line combining both ideas), remove the conflict markers, then commit the resolved file.

### Merging the pull request

Once the review is approved and any conflicts are resolved, the PR is **merged** into `main` — its commits become part of the main history, and the feature is officially part of the project. Many teams then delete the feature branch since its job is done.

### Try it yourself

1. Create a branch, make a small change, commit it, and write a pull request description as if you were submitting it to a real team.
2. Find an open-source project on GitHub and read through a few of its merged pull requests — notice how reviewers leave comments.
3. Practice resolving a merge conflict by deliberately editing the same line on two branches and merging them.

### Key Takeaways
- Branches let developers work on features independently without disturbing the stable `main` branch.
- A **pull request** proposes merging your branch''s changes into another branch, with a description explaining the why.
- **Code review** gives teammates a chance to catch bugs and suggest improvements before code ships.
- **Merge conflicts** happen when two branches change the same lines differently — you resolve them by manually choosing the correct content.
- This branch → PR → review → merge workflow is the standard way professional teams collaborate safely on shared code.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l89', 'Intro to Deployment and Web Hosting', 'developers', 'Web Development', 'en', 'advanced', 35, 150, 89, '## Intro to Deployment and Web Hosting

You''ve built websites and apps that run perfectly on your own computer. But right now, nobody else in the world can visit them — they only exist on YOUR machine. **Deployment** is the process of putting your code on a server so anyone, anywhere, can access it through the internet.

### From localhost to the real internet

When you run a project locally, it''s usually available at an address like `http://localhost:3000` — but `localhost` always means "this computer," so nobody else can type that into their browser and reach your project. To make it public, your code needs to live on a server that''s connected to the internet 24/7.

### What is a server, really?

A server is just a computer (often in a data center) that stays on, stays connected to the internet, and runs a program that listens for requests and sends back responses. You don''t need to own a physical server to deploy a website — **hosting providers** rent out server space and manage the hardware for you.

### Static vs. dynamic hosting

- **Static hosting** serves fixed files (HTML, CSS, JavaScript, images) exactly as they are. Great for portfolio sites, documentation, or any frontend that doesn''t need a server-side database. Providers like Netlify, Vercel, and GitHub Pages specialize in this.
- **Dynamic hosting** runs actual backend code (like a Node.js or Python server) that can talk to a database, handle logins, and generate different responses for different users. Providers like Render, Railway, and Heroku-style platforms specialize in this.

### A simple deployment example

Let''s say you have a small Express server:

```javascript
const express = require("express");
const app = express();

app.get("/", (req, res) => {
    res.send("Hello from my deployed app!");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`Server running on port ${PORT}`);
});
```

Notice `process.env.PORT` — most hosting providers assign your app a port number automatically through an **environment variable**, rather than letting you hardcode `3000`. Writing flexible code like this is essential for deployment to work.

### Environment variables and secrets

Speaking of environment variables — never hardcode passwords, API keys, or database URLs directly in your code. Instead, store them as environment variables that your hosting provider injects securely at runtime.

```bash
# .env file (never committed to Git!)
DATABASE_URL=postgres://user:password@host:5432/mydb
API_KEY=sk_live_abc123xyz
```

```javascript
// In your code, read secrets from process.env instead of hardcoding them
const dbUrl = process.env.DATABASE_URL;
```

Most teams add `.env` to a `.gitignore` file so secrets never get committed to version control by accident.

### A typical deployment workflow

1. Push your finished code to a Git repository (e.g. on GitHub).
2. Connect your hosting provider to that repository.
3. The provider automatically builds your project (installing dependencies, compiling code).
4. The provider starts your app and assigns it a public URL.
5. Every time you push new commits, the provider can automatically redeploy the latest version — this is called **continuous deployment**.

### Domains and DNS (a quick peek)

By default your deployed app usually gets a generated URL like `my-app-x7k2.onrender.com`. If you want a custom address like `myapp.com`, you purchase a **domain name** and configure **DNS** (Domain Name System) records to point that domain at your hosting provider''s servers.

### Try it yourself

1. Take a simple static HTML page and deploy it using a free static hosting provider.
2. Identify which parts of a project you''ve built would need "static" hosting versus "dynamic" hosting.
3. Practice creating a `.env` file and a matching `.gitignore` entry so secrets never get committed.

### Key Takeaways
- Deployment means putting your code on a server connected to the internet so anyone can access it.
- Static hosting serves fixed files; dynamic hosting runs backend code that can talk to databases.
- Use environment variables (like `process.env.PORT`) instead of hardcoding values that change between your computer and the live server.
- Never commit secrets like API keys or database passwords — store them as environment variables and add `.env` to `.gitignore`.
- Continuous deployment automatically redeploys your app whenever new code is pushed to your repository.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l90', 'Full-Stack Project: Planning Your App', 'developers', 'Capstone', 'en', 'advanced', 45, 250, 90, '## Full-Stack Project: Planning Your App

Welcome to the start of your Developers capstone project! Over the next several lessons, you''ll design, build, and connect a complete full-stack application — a frontend, a backend, and a database working together, just like real production apps. Today is entirely about PLANNING, before you write a single line of app code. Good planning saves you from painful rewrites later.

### Step 1: Pick an idea you actually care about

Choose something small enough to finish, but interesting enough to keep you motivated. Good capstone ideas are usually "CRUD" apps (Create, Read, Update, Delete) wrapped around one core idea. Some examples:

- A personal habit tracker
- A class trivia quiz game with a leaderboard
- A book or game collection catalog
- A to-do list with categories and due dates
- A simple recipe box with ingredients and steps

Avoid picking something that needs real-time multiplayer, payments, or AI for your FIRST full-stack project — those add huge complexity. Save big ideas for later; nail the fundamentals first.

### Step 2: Define your core features (MVP)

List the smallest set of features that would make your app actually useful — this is your **Minimum Viable Product (MVP)**. Resist the urge to list 20 features; pick 3-5 essential ones.

```text
App idea: Habit Tracker

MVP features:
1. User can add a new habit (e.g. "Drink water", "Read 20 minutes")
2. User can mark a habit as done for today
3. User can see a list of all their habits and today''s status
4. User can delete a habit they no longer want to track

Stretch features (later, if time allows):
- Streak counter (days in a row completed)
- Charts showing progress over time
- Reminders/notifications
```

### Step 3: Design your database schema

Sketch out what tables you need and how they relate — this connects directly back to what you learned about SQL joins and relationships.

```sql
CREATE TABLE habits (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE habit_logs (
    id INTEGER PRIMARY KEY,
    habit_id INTEGER REFERENCES habits(id),
    completed_on DATE NOT NULL
);
```

Here, one habit can have MANY logs (one per day completed) — a one-to-many relationship, just like classes and enrollments earlier in this course.

### Step 4: Plan your API endpoints

List out the backend routes your frontend will need to call. This becomes your contract between frontend and backend.

```text
GET    /api/habits           -> list all habits
POST   /api/habits           -> create a new habit
DELETE /api/habits/:id       -> delete a habit
POST   /api/habits/:id/log   -> mark a habit done for today
```

### Step 5: Sketch your pages/screens

Draw (on paper or digitally) the screens your app needs and what''s on each one. Even rough boxes-and-labels sketches ("wireframes") help enormously before writing any frontend code.

```text
[ Home Page ]
 - Title: "My Habits"
 - List of habit cards, each showing: name, done-today checkbox, delete button
 - "+ Add Habit" button at the bottom that opens a small form
```

### Step 6: Write your project plan document

Capture everything above in a single planning document — you''ll thank yourself later when you''re deep in the build and forget your original plan.

### Checklist for this lesson
- [ ] Chosen a specific, scoped app idea
- [ ] Written a clear MVP feature list (3-5 features)
- [ ] Sketched a database schema with at least one relationship
- [ ] Listed the API endpoints needed to support your MVP
- [ ] Sketched wireframes for each screen your app needs
- [ ] Saved your plan somewhere you''ll actually look at it again

### Key Takeaways
- Planning before coding saves time and avoids painful rewrites later in a full-stack project.
- An MVP (Minimum Viable Product) is the smallest set of features that makes your app genuinely useful.
- Sketch your database schema first — it shapes both your backend and frontend decisions.
- Listing API endpoints up front creates a clear contract between your frontend and backend.
- Wireframing screens before coding helps you think through the user experience early.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l91', 'Full-Stack Project: Building the Backend', 'developers', 'Capstone', 'en', 'advanced', 45, 250, 91, '## Full-Stack Project: Building the Backend

With your plan from the last lesson in hand, it''s time to build the backend — the part of your app that stores data and responds to requests. By the end of this lesson, you should have a working API you can test, even before any frontend exists.

### Step 1: Set up your project

```bash
mkdir my-app-backend
cd my-app-backend
npm init -y
npm install express
```

This creates a new Node.js project and installs Express, a popular framework for building web servers and APIs.

### Step 2: Create a basic server

```javascript
const express = require("express");
const app = express();
app.use(express.json()); // lets us read JSON request bodies

app.get("/", (req, res) => {
    res.send("Habit Tracker API is running!");
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server listening on port ${PORT}`));
```

Run it with `node server.js` and visit `http://localhost:3000` to confirm it works before adding more.

### Step 3: Set up your database connection

Using the schema you designed last lesson, connect to a real database (Postgres, SQLite, or whatever your course uses).

```javascript
const { Pool } = require("pg");
const pool = new Pool({ connectionString: process.env.DATABASE_URL });

async function getAllHabits() {
    const result = await pool.query("SELECT * FROM habits ORDER BY created_at");
    return result.rows;
}
```

### Step 4: Build each API endpoint from your plan

Go through your endpoint list one at a time. Build, test, repeat.

```javascript
// GET /api/habits -> list all habits
app.get("/api/habits", async (req, res) => {
    const habits = await getAllHabits();
    res.json(habits);
});

// POST /api/habits -> create a new habit
app.post("/api/habits", async (req, res) => {
    const { name } = req.body;
    if (!name || name.trim() === "") {
        return res.status(400).json({ error: "Habit name is required" });
    }
    const result = await pool.query(
        "INSERT INTO habits (name) VALUES ($1) RETURNING *",
        [name]
    );
    res.status(201).json(result.rows[0]);
});

// DELETE /api/habits/:id -> remove a habit
app.delete("/api/habits/:id", async (req, res) => {
    await pool.query("DELETE FROM habits WHERE id = $1", [req.params.id]);
    res.status(204).send();
});
```

Notice the parameterized queries (`$1`) — exactly the SQL injection defense you learned earlier in this course, now used for real.

### Step 5: Validate input and handle errors

Never trust what arrives in a request body. Check for missing fields, wrong types, and anything else that could crash your server or corrupt your data.

```javascript
app.post("/api/habits/:id/log", async (req, res) => {
    try {
        const habitId = req.params.id;
        const today = new Date().toISOString().slice(0, 10);
        await pool.query(
            "INSERT INTO habit_logs (habit_id, completed_on) VALUES ($1, $2)",
            [habitId, today]
        );
        res.status(201).json({ message: "Logged!" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: "Something went wrong logging this habit." });
    }
});
```

### Step 6: Test every endpoint before moving on

Use a tool like Postman, Insomnia, or even `curl` to manually call each endpoint and check the response — don''t wait until you''ve built the frontend to discover a backend bug.

```bash
curl -X POST http://localhost:3000/api/habits \
  -H "Content-Type: application/json" \
  -d ''{"name": "Drink water"}''
```

### Checklist for this lesson
- [ ] Backend server starts and responds at a basic route
- [ ] Database connection works and matches your planned schema
- [ ] Every endpoint from your plan is implemented
- [ ] Input validation exists for at least the create/update endpoints
- [ ] Every endpoint has been manually tested and returns the expected response

### Key Takeaways
- Build and test backend endpoints one at a time rather than all at once.
- Use parameterized queries for every database call that includes user input — never string-concatenate SQL.
- Validate incoming request data and handle errors gracefully instead of letting the server crash.
- Manually testing endpoints with curl/Postman before building the frontend saves debugging time later.
- A solid backend built from a clear plan makes the next step — connecting a frontend — far easier.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l92', 'Full-Stack Project: Building the Frontend', 'developers', 'Capstone', 'en', 'advanced', 45, 250, 92, '## Full-Stack Project: Building the Frontend

Your backend can store and serve data — now it''s time to build the part users actually SEE and interact with: the frontend. Today you''ll build the screens you sketched during planning, using placeholder/sample data first, before wiring up real backend calls in the next lesson.

### Step 1: Set up your frontend structure

You can build your frontend with plain HTML/CSS/JavaScript, or a framework like React — use whatever your course has covered. Either way, start from your wireframes.

```html
<!DOCTYPE html>
<html>
<head>
    <title>My Habit Tracker</title>
    <link rel="stylesheet" href="styles.css">
</head>
<body>
    <h1>My Habits</h1>
    <div id="habit-list"></div>
    <button id="add-habit-btn">+ Add Habit</button>
    <script src="app.js"></script>
</body>
</html>
```

### Step 2: Build with placeholder data first

Don''t wait for the backend connection to start building the UI — use fake sample data so you can focus entirely on layout and interaction first.

```javascript
const sampleHabits = [
    { id: 1, name: "Drink water", doneToday: true },
    { id: 2, name: "Read 20 minutes", doneToday: false },
    { id: 3, name: "Stretch", doneToday: false },
];

function renderHabits(habits) {
    const list = document.getElementById("habit-list");
    list.innerHTML = "";
    for (const habit of habits) {
        const card = document.createElement("div");
        card.className = "habit-card";
        card.innerHTML = `
            <span>${habit.name}</span>
            <input type="checkbox" ${habit.doneToday ? "checked" : ""} />
            <button class="delete-btn">Delete</button>
        `;
        list.appendChild(card);
    }
}

renderHabits(sampleHabits);
```

### Step 3: Add interactivity

Wire up clicks and form submissions to update your LOCAL state first (still no backend yet) — this lets you fully test the user experience in isolation.

```javascript
document.getElementById("add-habit-btn").addEventListener("click", () => {
    const name = prompt("New habit name:");
    if (name && name.trim() !== "") {
        sampleHabits.push({ id: Date.now(), name, doneToday: false });
        renderHabits(sampleHabits);
    }
});
```

### Step 4: Style it so it''s actually pleasant to use

A working app that''s hard to read won''t get used. Apply basic spacing, color, and clear typography.

```css
.habit-card {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 12px;
    margin-bottom: 8px;
    border-radius: 8px;
    background-color: #f0f4ff;
}

.delete-btn {
    background-color: #ff5c5c;
    color: white;
    border: none;
    border-radius: 4px;
    padding: 6px 10px;
    cursor: pointer;
}
```

### Step 5: Handle empty and loading states

What does your app look like before any habits exist, or while data is loading? Plan for those states now instead of leaving a blank confusing screen.

```javascript
function renderHabits(habits) {
    const list = document.getElementById("habit-list");
    if (habits.length === 0) {
        list.innerHTML = "<p>No habits yet — add your first one below!</p>";
        return;
    }
    // ... render habit cards as before
}
```

### Step 6: Keep components/functions focused

Just like in earlier lessons on clean code, keep each function doing ONE job — a `renderHabits` function that also fetches data AND handles clicks AND validates input gets hard to debug fast.

### Checklist for this lesson
- [ ] Every screen from your wireframes is built with HTML/CSS
- [ ] Sample/placeholder data renders correctly on the page
- [ ] Buttons and forms respond to clicks (even if only updating local state for now)
- [ ] Empty states and basic styling are handled, not left blank or broken
- [ ] Code is organized into small, focused functions

### Key Takeaways
- Build the frontend against placeholder data first so you can iterate on layout and interaction without backend dependencies.
- Wireframes from the planning lesson directly guide what HTML structure you build.
- Always design for empty/loading states, not just the "happy path" with perfect data.
- Basic, consistent styling makes a working app feel genuinely usable.
- Keep frontend functions focused on one job each, just like good backend code.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l93', 'Full-Stack Project: Connecting Frontend and Backend', 'developers', 'Capstone', 'en', 'advanced', 45, 250, 93, '## Full-Stack Project: Connecting Frontend and Backend

You have a working backend API and a frontend built against fake sample data. Today is the exciting part: replacing that fake data with REAL calls to your own backend, so your app becomes a genuine full-stack application.

### Step 1: Replace sample data with a fetch call

Instead of a hardcoded array, ask the backend for real data using the `fetch` API.

```javascript
async function loadHabits() {
    const response = await fetch("http://localhost:3000/api/habits");
    if (!response.ok) {
        throw new Error(`Failed to load habits: ${response.status}`);
    }
    const habits = await response.json();
    renderHabits(habits);
}

loadHabits();
```

### Step 2: Send data to the backend on create

Update your "Add Habit" button to POST to your real API instead of just pushing into a local array.

```javascript
document.getElementById("add-habit-btn").addEventListener("click", async () => {
    const name = prompt("New habit name:");
    if (!name || name.trim() === "") return;

    const response = await fetch("http://localhost:3000/api/habits", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ name }),
    });

    if (response.ok) {
        loadHabits(); // refresh the list with the latest data from the server
    } else {
        alert("Couldn''t add habit — please try again.");
    }
});
```

### Step 3: Wire up delete and update actions

Repeat the same pattern for every other action in your app — each button or form should now talk to the real backend.

```javascript
async function deleteHabit(habitId) {
    const response = await fetch(`http://localhost:3000/api/habits/${habitId}`, {
        method: "DELETE",
    });
    if (response.ok) {
        loadHabits();
    }
}
```

### Step 4: Handle loading and error states for real

Now that you''re making real network requests, things can genuinely fail — the server might be down, the network might be slow, or a request might return an error. Show that to the user instead of leaving a silent blank screen.

```javascript
async function loadHabits() {
    const list = document.getElementById("habit-list");
    list.innerHTML = "<p>Loading...</p>";
    try {
        const response = await fetch("http://localhost:3000/api/habits");
        if (!response.ok) throw new Error("Server error");
        const habits = await response.json();
        renderHabits(habits);
    } catch (error) {
        list.innerHTML = "<p>Something went wrong loading your habits. Please refresh.</p>";
        console.error(error);
    }
}
```

### Step 5: Solve CORS issues if you hit them

If your frontend and backend run on different ports (very common during development), the browser may block requests due to **CORS** (Cross-Origin Resource Sharing) restrictions. Fix this on the backend:

```javascript
const cors = require("cors");
app.use(cors()); // allows requests from other origins during development
```

### Step 6: Test the full loop end-to-end

Walk through every feature exactly as a real user would: add a habit, see it appear, mark it done, delete it, refresh the page and confirm the data persisted (since it''s now coming from a real database, not memory).

### Checklist for this lesson
- [ ] Every fake/sample data call is replaced with a real `fetch` to your backend
- [ ] Create, read, update, and delete actions all talk to the real API
- [ ] Loading and error states are visible to the user, not silent failures
- [ ] CORS is configured if frontend and backend run on different origins
- [ ] You''ve manually tested the full create-view-update-delete loop end-to-end

### Key Takeaways
- Connecting frontend to backend means replacing fake data with real `fetch` calls to your API endpoints.
- Always handle loading and error states for real network requests — they can and will sometimes fail.
- CORS errors are common during local development when frontend and backend run on different ports; the backend must explicitly allow cross-origin requests.
- Refreshing the page and seeing your data persist confirms the full stack — frontend, backend, and database — is genuinely working together.
- Testing the complete user flow end-to-end catches integration bugs that testing each half separately would miss.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l94', 'Code Review Best Practices', 'developers', 'Best Practices', 'en', 'advanced', 35, 150, 94, '## Code Review Best Practices

You learned how pull requests and code review fit into a Git workflow. Now let''s go deeper into HOW to give and receive code review well — a skill that''s just as important as writing the code itself, and one that separates good teammates from difficult ones.

### Why code review matters

Code review isn''t about catching every developer making mistakes — everyone does. It''s about:
- Catching bugs before they reach users
- Sharing knowledge across the team about how parts of the codebase work
- Keeping code style and quality consistent
- Giving newer developers feedback and mentorship

### Giving good feedback: be specific and kind

Vague feedback like "this is messy" doesn''t help anyone. Specific, actionable feedback does.

```text
Not helpful:
"This function is bad."

Helpful:
"This function does three different things (validating input,
saving to the database, and sending an email). Could we split
it into three smaller functions? It would make each one easier
to test on its own."
```

### Distinguish between blocking issues and suggestions

Not every comment needs to stop a merge. Make it clear what''s a MUST FIX versus a nice-to-have idea.

```text
"BLOCKING: This SQL query concatenates user input directly —
this is vulnerable to SQL injection. Please use a parameterized
query instead before we merge this."

"SUGGESTION (non-blocking): Consider renaming `data` to
`userProfile` here — totally optional, just thought it might
read more clearly."
```

### Ask questions instead of assuming

If something is confusing, ask rather than assume the author made a mistake — sometimes there''s context you''re missing.

```text
"I notice this loop runs twice — is that intentional for retry
logic, or could this be simplified to run once?"
```

### Review the SMALL stuff and the BIG stuff

Good reviewers check both levels:
- **Small stuff**: typos, naming, formatting, missing comments
- **Big stuff**: Does this solve the actual problem? Are there edge cases that break it? Is there a simpler approach?

It''s easy to get distracted nitpicking variable names and miss that the core logic has a bug — try to comment on both, but prioritize the big stuff.

### Receiving feedback well

When YOUR code gets reviewed, remember: feedback on your code is not feedback on your worth as a developer. Try to:
- Read comments fully before reacting
- Ask for clarification if a comment is unclear, rather than guessing
- Say "thanks, good catch" when someone finds a real bug — they just saved you from a problem in production
- Push back respectfully if you disagree, explaining your reasoning, rather than silently ignoring the comment

```text
"Good catch — I hadn''t considered what happens when the cart
is empty. I''ll add a check for that and push an update."
```

### Keep pull requests small

Reviewing a 1,000-line pull request is exhausting and error-prone — reviewers start skimming instead of reading carefully. Whenever possible, break large features into smaller, independently reviewable pull requests.

### A simple code review checklist

```text
- [ ] Does the code do what the PR description says it does?
- [ ] Are there tests, and do they cover edge cases?
- [ ] Is there any duplicated logic that could be reused instead?
- [ ] Are variable/function names clear and accurate?
- [ ] Any security concerns (unescaped input, exposed secrets)?
- [ ] Would a new team member understand this code without explanation?
```

### Try it yourself

1. Find a snippet of code you''ve written recently and write a code review comment as if YOU were reviewing someone else''s submission of it.
2. Practice rewriting a vague piece of feedback ("this is confusing") into a specific, actionable comment.
3. Read through the code review checklist above and apply it to a project you''ve already built.

### Key Takeaways
- Code review exists to catch bugs early, share knowledge, and keep quality consistent — not to criticize people.
- Give specific, actionable feedback, and clearly separate blocking issues from optional suggestions.
- Ask questions instead of assuming mistakes — there may be context you''re missing.
- Review both small details (naming, style) and big-picture concerns (correctness, edge cases, security).
- Receive feedback graciously; it''s about the code, not your worth as a developer.
- Smaller pull requests get better, more careful reviews than huge ones.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l95', 'Writing Technical Documentation', 'developers', 'Best Practices', 'en', 'advanced', 35, 150, 95, '## Writing Technical Documentation

Code tells a computer what to do. Documentation tells HUMANS what your code does, why it exists, and how to use it. Even brilliant code is hard to use, maintain, or contribute to if nobody besides the original author understands it. Today you''ll learn to write documentation that actually helps people.

### Why documentation matters

Imagine joining a new project with zero comments, no README, and cryptic variable names. You''d have to read every line of code just to figure out how to run it. Good documentation saves everyone — including FUTURE YOU — enormous time.

### The README: your project''s front door

Every project should have a `README.md` file that answers the basic questions a new visitor has within the first 30 seconds.

```markdown
# Habit Tracker

A simple full-stack app for tracking daily habits.

## Features
- Add and delete habits
- Mark habits complete for the day
- View your habit list at a glance

## Setup
1. Clone this repository
2. Run `npm install` to install dependencies
3. Create a `.env` file with your `DATABASE_URL`
4. Run `npm start` to launch the server
5. Open `http://localhost:3000` in your browser

## Tech Stack
- Backend: Node.js, Express, PostgreSQL
- Frontend: HTML, CSS, vanilla JavaScript
```

A good README typically includes: what the project does, how to set it up, and how to run it — in that order.

### Code comments: explain WHY, not WHAT

Comments shouldn''t restate code in English — they should explain reasoning that isn''t obvious from the code itself.

```javascript
// BAD comment — just repeats what the code already says
// increment count by 1
count += 1;

// GOOD comment — explains non-obvious reasoning
// We start the streak count at 1 (not 0) because completing
// a habit today already counts as day one of the streak.
let streakCount = 1;
```

### Function documentation

For functions other developers will call, document the inputs, outputs, and any important behavior.

```javascript
/**
 * Calculates the current streak length for a habit.
 * @param {Date[]} completedDates - Sorted list of dates the habit was completed.
 * @returns {number} The number of consecutive days completed, ending today.
 *
 * Note: returns 0 if the habit was not completed today or yesterday,
 * even if there was a long streak earlier.
 */
function calculateStreak(completedDates) {
    // ...
}
```

This kind of comment block lets another developer use the function correctly WITHOUT reading its full implementation.

### API documentation

If you built a backend API, document every endpoint so frontend developers (including future-you) know how to use it without reading the backend source code.

```markdown
## API Reference

### GET /api/habits
Returns a list of all habits.

**Response 200:**
```json
[
  { "id": 1, "name": "Drink water", "doneToday": true }
]
```

### POST /api/habits
Creates a new habit.

**Request body:**
```json
{ "name": "Read 20 minutes" }
```

**Response 201:** the newly created habit object.
**Response 400:** if `name` is missing or empty.
```

### Keep documentation up to date

Outdated documentation is often worse than NO documentation, because it actively misleads people. Whenever you change behavior, update the relevant docs in the SAME pull request — don''t leave it for "later," because later rarely comes.

### Try it yourself

1. Write a README for a project you''ve already built in this course, following the structure above.
2. Take a function you wrote recently and add a documentation comment explaining its inputs, outputs, and any tricky behavior.
3. Document one API endpoint from your capstone backend, including example request and response bodies.

### Key Takeaways
- A good README explains what a project does, how to set it up, and how to run it.
- Comments should explain WHY code does something non-obvious, not restate WHAT the code already says.
- Function documentation describing inputs, outputs, and edge cases lets others use your code without reading its internals.
- API documentation should include example requests and responses for every endpoint.
- Outdated documentation can be more harmful than none — update docs in the same change that updates behavior.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l96', 'Intro to Open Source Contribution', 'developers', 'Career', 'en', 'advanced', 35, 150, 96, '## Intro to Open Source Contribution

So much of the software you use every day — programming languages, libraries, even entire operating systems — is **open source**, meaning its code is publicly available for anyone to read, use, and even improve. Contributing to open source is one of the best ways to grow as a developer AND build a public record of real-world experience. Let''s learn how it works.

### What does "open source" mean?

An open source project publishes its source code publicly (often on GitHub) under a **license** that grants others permission to use, copy, modify, and sometimes redistribute it. Popular examples include the Linux operating system, the React library, Python itself, and thousands of smaller tools and libraries.

### Why contribute?

- You get real experience reading and working with large, established codebases.
- Your contributions become part of your public portfolio — anyone can see your work.
- You learn directly from experienced developers through code review feedback.
- You give back to tools that you and millions of others rely on.

### Finding a project to contribute to

Look for projects that are:
- Actively maintained (recent commits, responsive maintainers)
- Welcoming to new contributors (look for a `CONTRIBUTING.md` file)
- Labeled with beginner-friendly tags like `good first issue` or `help wanted`

```text
GitHub search tip:
label:"good first issue" language:javascript state:open
```

Many platforms let you filter issues by these labels directly — they''re specifically marked by maintainers as approachable for newcomers.

### The contribution workflow

1. **Fork** the repository — this creates your own personal copy on GitHub.
2. **Clone** your fork to your computer so you can edit it locally.
3. Create a **branch** for your change, just like you learned in the version control lesson.
4. Make your change, following the project''s existing code style.
5. **Commit** and push your branch to your fork.
6. Open a **pull request** from your fork back to the original project.
7. Respond to **code review** feedback from maintainers.
8. Celebrate when it''s merged — your code is now part of a real project used by others!

```bash
# Example contribution workflow
git clone https://github.com/your-username/project-name.git
cd project-name
git checkout -b fix-typo-in-readme
# ... make your edit ...
git add README.md
git commit -m "Fix typo in installation instructions"
git push origin fix-typo-in-readme
# Then open a pull request on GitHub from your branch
```

### Start small

Your first contribution doesn''t need to be a major feature. Fixing a typo in documentation, improving an error message, or adding a missing test are all genuinely valuable first contributions — and they teach you the WORKFLOW before you tackle something complex.

### Reading CONTRIBUTING.md and code of conduct

Most serious projects include a `CONTRIBUTING.md` file explaining exactly how they want contributions submitted (coding style, commit message format, testing requirements). Read it before opening your pull request — ignoring it is one of the most common reasons first-time PRs get rejected.

### Be patient and professional

Maintainers are often volunteers reviewing contributions in their spare time. If your PR doesn''t get a response immediately, that''s normal — be patient, and respond politely and promptly when feedback does arrive.

### Try it yourself

1. Browse GitHub for a project using a language you know, and find an issue labeled `good first issue`.
2. Read that project''s `CONTRIBUTING.md` file (if it has one) and summarize its key rules.
3. Practice the fork → clone → branch → PR workflow on a small, low-stakes documentation fix.

### Key Takeaways
- Open source projects publish their code publicly under a license allowing others to use and contribute to it.
- Contributing builds real-world experience, a public portfolio, and mentorship opportunities through code review.
- Look for actively maintained projects with `good first issue` labels and a `CONTRIBUTING.md` file.
- The standard workflow is: fork, clone, branch, commit, push, open a pull request, then respond to review.
- Starting with small contributions (typos, docs, small bug fixes) is a great way to learn the process.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l97', 'Developers Capstone Project: Build Your Own App', 'developers', 'Capstone', 'en', 'advanced', 45, 250, 97, '## Developers Capstone Project: Build Your Own App

This is it — your big capstone build. Using everything from this entire Developers track (logic, data structures, SQL, security, Git workflows, full-stack development), you''re going to design and build a complete app of your OWN choosing, from scratch. This lesson is your project guide and checklist for the build itself.

### Choosing your own project

Unlike the guided full-stack project earlier in this course, this capstone is YOUR idea. Pick something that excites you. Some inspiration:

- A multiplayer-style trivia or quiz game with score tracking
- A personal finance tracker for allowance/savings goals
- A community board game or book recommendation app
- A simple social app where users post and react to short messages
- A game (text-based or simple browser game) with a saved high-score leaderboard

### Scope it realistically

Use the planning skills from earlier: define your MVP, sketch your schema, list your endpoints, sketch your screens. A SMALL finished app is far more valuable than a huge unfinished one.

```text
Capstone Planning Template:

App name: ____________________
One-sentence pitch: ____________________

MVP features (3-5 max):
1. ____________________
2. ____________________
3. ____________________

Database tables and relationships:
____________________

API endpoints needed:
____________________

Screens/pages needed:
____________________
```

### Apply security from the start

This is your chance to build security in from day one rather than bolting it on later:
- Use parameterized queries for every database call.
- Escape any user-generated content before rendering it as HTML.
- Validate input on both frontend AND backend (never trust the frontend alone).
- Never commit secrets — use environment variables.

### Use good data structures where they fit

Think about whether a stack, queue, linked list, or tree naturally fits part of your app — for example, an undo feature (stack), a task queue (queue), or nested comments (tree).

### Follow a real Git workflow

Don''t just commit everything to `main` directly. Practice the professional workflow:
- Create feature branches for each chunk of work
- Write clear commit messages
- If working with a partner or in a study group, open pull requests and review each other''s code

### Document as you go

Don''t leave documentation for the very end. Update your README and comment tricky code AS you write it — it''s much harder to remember your own reasoning weeks later.

### Build incrementally and test constantly

Don''t write your entire backend, then your entire frontend, then test everything at once. Build one feature completely (backend endpoint + frontend UI + connection), test it end-to-end, then move to the next feature.

```text
Suggested build order:
1. Set up backend skeleton + database schema
2. Build and test ONE full feature end-to-end (e.g. "create item")
3. Build and test the next feature
4. Repeat until your MVP list is complete
5. Polish styling and handle edge cases
6. Final full walkthrough test of every feature
```

### Capstone checklist

- [ ] Project plan written (MVP, schema, endpoints, wireframes)
- [ ] Backend built with working, tested API endpoints
- [ ] Frontend built and connected to the real backend
- [ ] Security practices applied (parameterized queries, input escaping, validated input)
- [ ] Used Git branches and meaningful commit messages throughout
- [ ] README and key code comments written
- [ ] Every MVP feature works end-to-end when tested manually
- [ ] Edge cases handled (empty states, invalid input, network errors)

### Key Takeaways
- The capstone is your chance to combine everything learned in this track into one project of your own choosing.
- Scope your MVP realistically — a small finished app beats a huge unfinished one.
- Build security in from the start: parameterized queries, escaped output, and validated input.
- Build and test one complete feature at a time rather than building everything before testing anything.
- Document and use good Git habits throughout the build, not just at the end.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l98', 'Preparing Your Developer Portfolio', 'developers', 'Career', 'en', 'advanced', 35, 150, 98, '## Preparing Your Developer Portfolio

You''ve built real projects throughout this entire course — now let''s make sure the world can actually SEE them. A developer portfolio is how you show your skills to future teachers, mentors, schools, or eventually employers. Today is a project guide for assembling a portfolio that highlights your best work.

### What goes in a portfolio?

A strong beginner developer portfolio typically includes:
- A short introduction about who you are and what you''re interested in
- 2-4 of your BEST projects (quality over quantity)
- Links to your code (e.g. a GitHub profile)
- Contact information (only what you''re comfortable sharing publicly)

### Choosing which projects to feature

Don''t include every single exercise you''ve ever done — pick the projects that best show off real skills, ideally including your full-stack capstone.

```text
Good project to feature:
- Your capstone app (shows full-stack skills, planning, and follow-through)
- A project demonstrating a specific skill (e.g. an algorithm visualizer,
  a game using data structures, a small open source contribution)

Not ideal to feature:
- A single-file "Hello World" exercise
- An unfinished, broken project with no description
```

### Writing a project description

For each featured project, write a short summary explaining what it does, what you used to build it, and what you learned or found challenging.

```markdown
## Habit Tracker

A full-stack web app for tracking daily habits, built with
Node.js, Express, PostgreSQL, and vanilla JavaScript.

**What it does:** Lets users add habits, mark them complete
each day, and see their full list at a glance.

**What I learned:** This was my first time connecting a real
database to a backend API and building a frontend that fetches
live data instead of using fake sample data. Debugging a CORS
issue between my frontend and backend taught me a lot about
how browsers handle cross-origin requests.

**Try it:** [link to live demo]
**Code:** [link to GitHub repository]
```

Notice this description doesn''t just describe features — it shows REFLECTION on what was learned, which is something reviewers and mentors genuinely value.

### Cleaning up your GitHub profile

Your GitHub profile is often the first thing people check. A few easy improvements:
- Make sure your best repositories have clear README files (from the documentation lesson!)
- Remove or archive old throwaway test repositories that don''t represent your skill
- Add a short bio to your GitHub profile

### Building a simple portfolio site

You don''t need anything fancy — a single clean page listing your projects is enough to start.

```html
<!DOCTYPE html>
<html>
<head><title>My Developer Portfolio</title></head>
<body>
    <h1>Hi, I''m a student developer!</h1>
    <p>I build web apps and enjoy working on full-stack projects.</p>

    <h2>Projects</h2>
    <div class="project-card">
        <h3>Habit Tracker</h3>
        <p>A full-stack app for tracking daily habits...</p>
        <a href="https://github.com/you/habit-tracker">View Code</a>
    </div>
</body>
</html>
```

You could deploy this very page using the static hosting skills from earlier in this course!

### Keep it updated

A portfolio is never really "finished" — as you build new projects and learn new skills, swap out older, weaker examples for stronger, more recent ones.

### Try it yourself

1. List your top 3 projects from this entire course and write a short description for each, following the template above.
2. Clean up your GitHub profile: check that your best repos have README files.
3. Build a simple one-page HTML portfolio site listing your featured projects, and deploy it using a static hosting provider.

### Key Takeaways
- A portfolio should feature your BEST few projects with clear descriptions, not every exercise you''ve ever written.
- Good project descriptions explain what the project does, what you built it with, and what you learned.
- Clean, well-documented GitHub repositories make a strong first impression.
- A simple, deployed portfolio site is enough to start — it doesn''t need to be fancy.
- Keep your portfolio updated as you build new projects and grow your skills.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;

INSERT INTO lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES
('dev-l99', 'Developers Graduation: Your Path Forward in Coding', 'developers', 'Career', 'en', 'advanced', 45, 250, 99, '## Developers Graduation: Your Path Forward in Coding

Congratulations — you''ve reached the final lesson of the Developers track! Look back at everything you''ve learned: programming fundamentals, data structures, algorithms, databases, security, full-stack development, Git workflows, and a real capstone project. This lesson is about reflecting on that journey and planning what comes next.

### Look back at how far you''ve come

It''s easy to forget the climb once you''re partway up the mountain. Take a moment to genuinely reflect:

```text
Reflection prompts:
- What was the hardest concept you struggled with, and how did
  you eventually understand it?
- What''s one bug you remember fixing that felt impossible at
  the time?
- Which project are you most proud of, and why?
- What''s something you can do now that you couldn''t do when
  you started this course?
```

Many experienced developers will tell you that the feeling of being confused and stuck is not a sign you''re bad at coding — it''s simply what learning looks like. You''ve now lived through that cycle dozens of times and come out the other side with real, working software.

### The skills you now genuinely have

By completing this track, you can:
- Design and query relational databases, including multi-table joins
- Reason about algorithm efficiency using Big-O notation
- Use core data structures (stacks, queues, linked lists, trees) appropriately
- Recognize and defend against common security vulnerabilities (XSS, SQL injection)
- Debug systematically using browser DevTools and structured strategies
- Collaborate using real Git workflows (branches, pull requests, code review)
- Build, connect, and deploy a complete full-stack application
- Write documentation and contribute to open source projects

That is a genuinely substantial, professional skill set — many working developers started with exactly this foundation.

### Where to go next

Coding is a field where there''s always more to learn, which is part of what makes it exciting rather than boring. Some directions to explore next:

- **Specialize deeper in a domain**: mobile app development, game development, data science/machine learning, cybersecurity, or systems programming.
- **Learn a new language**: now that you understand core concepts deeply, picking up a second or third programming language gets much easier — the syntax changes, but the thinking doesn''t.
- **Build bigger personal projects**: revisit your capstone idea and add the "stretch features" you set aside during planning.
- **Contribute more to open source**: now with a full project under your belt, look for slightly bigger issues to tackle.
- **Join coding communities**: hackathons, coding clubs, online forums, and open source communities are full of people who love building things together.

### Keep the habits that got you here

Some habits from this course will serve you for your entire coding journey, no matter what you build next:
- Breaking big problems into smaller, testable pieces
- Reading error messages carefully instead of panicking
- Writing code for HUMANS to read, not just computers to run
- Asking "what could go wrong here?" before shipping
- Documenting and reflecting on what you learn

### A note on what comes next for you specifically

Some of you will go on to study computer science formally. Some will keep building personal projects as a hobby. Some will start freelancing or contributing to real-world open source tools. Some will combine coding with a completely different passion — art, music, science, sports — and build tools nobody''s built before. All of these paths are valid, and the foundation you''ve built here travels with you into every one of them.

### Final checklist before you go

- [ ] Reflected on your growth and proudest project from this course
- [ ] Reviewed the full skill list above and recognize you can do all of it
- [ ] Chosen at least one direction you want to explore next
- [ ] Your capstone project and portfolio are saved somewhere you can return to
- [ ] You know that getting stuck is normal, and you now have real strategies for getting unstuck

### Key Takeaways
- You''ve built a genuinely professional foundation: databases, algorithms, data structures, security, full-stack development, and collaboration workflows.
- Struggling with hard concepts and debugging painful bugs is a normal, valuable part of becoming a developer — not a sign of failure.
- There are many valid paths forward: specializing in a domain, learning new languages, contributing to open source, or building bigger personal projects.
- The HABITS you''ve built — breaking down problems, reading errors carefully, documenting your work — matter more long-term than any single language or framework.
- This is a graduation from one stage, not an ending — coding is a lifelong skill you''ll keep growing for as long as you choose to use it.')
ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;
