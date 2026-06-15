-- =============================================================================
-- CODEship Academy — Developers Quizzes (dev-q01 to dev-q50)
-- Target: Ages 11–14 | JavaScript, Python, Web Dev
-- =============================================================================

INSERT INTO quizzes (slug, title, level, category, time_limit_seconds, passing_score, xp_reward) VALUES
('dev-q01', 'JavaScript Fundamentals Quiz',     'developers', 'JavaScript', 600, 70, 200),
('dev-q02', 'Variables and Data Types Quiz',     'developers', 'JavaScript', 600, 70, 200),
('dev-q03', 'Operators and Expressions Quiz',    'developers', 'JavaScript', 600, 70, 200),
('dev-q04', 'Conditionals Quiz',                 'developers', 'JavaScript', 600, 70, 200),
('dev-q05', 'Loops Quiz',                        'developers', 'JavaScript', 600, 70, 200),
('dev-q06', 'Functions Quiz',                    'developers', 'JavaScript', 600, 70, 200),
('dev-q07', 'Arrays Quiz',                       'developers', 'JavaScript', 600, 70, 200),
('dev-q08', 'Objects Quiz',                      'developers', 'JavaScript', 600, 70, 200),
('dev-q09', 'DOM Manipulation Quiz',             'developers', 'JavaScript', 600, 70, 200),
('dev-q10', 'Events and Listeners Quiz',         'developers', 'JavaScript', 600, 70, 200),
('dev-q11', 'String Methods Quiz',               'developers', 'JavaScript', 600, 70, 200),
('dev-q12', 'Array Methods Quiz',                'developers', 'JavaScript', 600, 70, 200),
('dev-q13', 'Math and Numbers Quiz',             'developers', 'JavaScript', 600, 70, 200),
('dev-q14', 'Error Handling Quiz',               'developers', 'JavaScript', 600, 70, 200),
('dev-q15', 'Scope and Closures Quiz',           'developers', 'JavaScript', 600, 70, 200),
('dev-q16', 'ES6+ Features Quiz',                'developers', 'JavaScript', 600, 70, 200),
('dev-q17', 'Async JavaScript Quiz',             'developers', 'JavaScript', 600, 70, 200),
('dev-q18', 'Fetch API Quiz',                    'developers', 'JavaScript', 600, 70, 200),
('dev-q19', 'Local Storage Quiz',                'developers', 'JavaScript', 600, 70, 200),
('dev-q20', 'JSON Quiz',                         'developers', 'JavaScript', 600, 70, 200),
('dev-q21', 'Python Basics Quiz',                'developers', 'Python',     600, 70, 200),
('dev-q22', 'Python Variables Quiz',             'developers', 'Python',     600, 70, 200),
('dev-q23', 'Python Lists Quiz',                 'developers', 'Python',     600, 70, 200),
('dev-q24', 'Python Dictionaries Quiz',          'developers', 'Python',     600, 70, 200),
('dev-q25', 'Python Functions Quiz',             'developers', 'Python',     600, 70, 200),
('dev-q26', 'Python Loops Quiz',                 'developers', 'Python',     600, 70, 200),
('dev-q27', 'Python Strings Quiz',               'developers', 'Python',     600, 70, 200),
('dev-q28', 'Python File I/O Quiz',              'developers', 'Python',     600, 70, 200),
('dev-q29', 'Python Classes Quiz',               'developers', 'Python',     600, 70, 200),
('dev-q30', 'Python Libraries Quiz',             'developers', 'Python',     600, 70, 200),
('dev-q31', 'Algorithms Basics Quiz',            'developers', 'CS Theory',  600, 70, 200),
('dev-q32', 'Sorting Algorithms Quiz',           'developers', 'CS Theory',  600, 70, 200),
('dev-q33', 'Data Structures Quiz',              'developers', 'CS Theory',  600, 70, 200),
('dev-q34', 'Binary and Number Systems Quiz',    'developers', 'CS Theory',  600, 70, 200),
('dev-q35', 'Web APIs Quiz',                     'developers', 'Web Dev',    600, 70, 200),
('dev-q36', 'CSS Animations Advanced Quiz',      'developers', 'CSS',        600, 70, 200),
('dev-q37', 'Git and Version Control Quiz',      'developers', 'Tools',      600, 70, 200),
('dev-q38', 'Command Line Basics Quiz',          'developers', 'Tools',      600, 70, 200),
('dev-q39', 'Debugging Techniques Quiz',         'developers', 'Tools',      600, 70, 200),
('dev-q40', 'Web Security Basics Quiz',          'developers', 'Security',   600, 70, 200),
('dev-q41', 'Database Concepts Quiz',            'developers', 'Databases',  600, 70, 200),
('dev-q42', 'SQL Basics Quiz',                   'developers', 'Databases',  600, 70, 200),
('dev-q43', 'APIs and REST Quiz',                'developers', 'Web Dev',    600, 70, 200),
('dev-q44', 'TypeScript Basics Quiz',            'developers', 'JavaScript', 600, 70, 200),
('dev-q45', 'React Basics Quiz',                 'developers', 'Frameworks', 600, 70, 200),
('dev-q46', 'Testing Basics Quiz',               'developers', 'Tools',      600, 70, 200),
('dev-q47', 'Performance Optimization Quiz',     'developers', 'Web Dev',    600, 70, 200),
('dev-q48', 'Accessibility Advanced Quiz',       'developers', 'Accessibility', 600, 70, 200),
('dev-q49', 'Developers Mid-Point Review Quiz',  'developers', 'Review',     600, 70, 200),
('dev-q50', 'Developers Final Assessment Quiz',  'developers', 'Assessment', 600, 70, 200)
ON CONFLICT (slug) DO NOTHING;

-- Q01: JavaScript Fundamentals
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q01', 'JavaScript is primarily used for:', '["Styling web pages","Structuring web pages","Making web pages interactive","Storing data in databases"]', 2, 'JavaScript adds interactivity and dynamic behaviour to web pages.', 1),
  ('dev-q01', 'How do you write a comment in JavaScript?', '["<!-- comment -->","/* comment */","// comment","# comment"]', 2, '// is for single-line comments. /* */ is for multi-line comments.', 2),
  ('dev-q01', 'Which tag links a JavaScript file in HTML?', '["<javascript>","<js>","<script>","<code>"]', 2, '<script src="file.js"></script> links an external JavaScript file.', 3),
  ('dev-q01', 'Where should you put <script> tags in HTML?', '["In <head>","In <body>","Just before </body>","In <meta>"]', 2, 'Best practice: just before </body> so HTML loads before JavaScript runs.', 4),
  ('dev-q01', 'console.log() is used to:', '["Show an alert box","Print to the browser console","Save data","Send a network request"]', 1, 'console.log() outputs values to the browser developer console.', 5),
  ('dev-q01', 'Which is NOT a JavaScript data type?', '["string","number","boolean","character"]', 3, 'JS has: string, number, boolean, null, undefined, object, symbol. Not "character".', 6),
  ('dev-q01', 'JavaScript was created by:', '["Tim Berners-Lee","Brendan Eich","Linus Torvalds","James Gosling"]', 1, 'Brendan Eich created JavaScript in 1995 in just 10 days!', 7),
  ('dev-q01', 'JavaScript runs in:', '["Only servers","Only browsers","Both browsers and servers (via Node.js)","Only mobile apps"]', 2, 'JavaScript originally ran in browsers, now also on servers via Node.js.', 8),
  ('dev-q01', 'The strict mode declaration is:', '["\"use strict\";","strict mode;","#strict","enable strict;"]', 0, '"use strict"; enables strict mode at the top of a file or function.', 9),
  ('dev-q01', 'Which statement is correct about JavaScript?', '["It is the same as Java","It is case-sensitive","It uses indentation for code blocks","It requires semicolons always"]', 1, 'JavaScript is case-sensitive: myVar and myvar are different variables.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q02: Variables
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q02', 'Which keyword declares a block-scoped variable that CAN be reassigned?', '["var","let","const","def"]', 1, 'let declares block-scoped variables that can be reassigned.', 1),
  ('dev-q02', 'Which keyword declares a variable that CANNOT be reassigned?', '["var","let","const","fixed"]', 2, 'const declares constants — the binding cannot be reassigned after declaration.', 2),
  ('dev-q02', 'What is the value of an uninitialized variable?', '["null","0","undefined","false"]', 2, 'Declared but uninitialized variables have the value undefined.', 3),
  ('dev-q02', 'typeof "hello" returns:', '["text","string","str","char"]', 1, 'typeof returns a string. typeof "hello" returns the string "string".', 4),
  ('dev-q02', 'typeof 42 returns:', '["integer","int","number","num"]', 2, 'typeof 42 returns "number". JS uses one type for all numbers.', 5),
  ('dev-q02', 'Naming convention for variables in JavaScript:', '["snake_case","PascalCase","camelCase","kebab-case"]', 2, 'camelCase is the standard JS naming convention: myVariableName.', 6),
  ('dev-q02', 'Which variable name is NOT valid in JavaScript?', '["myVar","_private","2coolForSchool","$price"]', 2, 'Variable names cannot start with a number. 2coolForSchool is invalid.', 7),
  ('dev-q02', 'What does null mean?', '["Variable not declared","Variable declared but empty","An intentional absence of value","Zero"]', 2, 'null is an intentional empty value — you deliberately set it to "nothing".', 8),
  ('dev-q02', 'Why is var considered outdated?', '["It is slower","It has function scope, not block scope, causing bugs","It cannot store strings","It is not supported anymore"]', 1, 'var has function scope — it leaks out of if/for blocks, causing tricky bugs.', 9),
  ('dev-q02', 'const with an object means:', '["The object cannot change at all","The variable cannot be reassigned, but object properties can change","The object is frozen","The object becomes immutable"]', 1, 'const prevents reassignment of the variable itself, not mutation of object contents.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q03: Operators
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q03', 'What does === do?', '["Assigns a value","Checks value equality only","Checks value AND type equality","Checks type only"]', 2, '=== (strict equality) checks that value AND type are the same.', 1),
  ('dev-q03', '"5" == 5 in JavaScript returns:', '["false (type mismatch)","true (loose equality coerces type)","Error","undefined"]', 1, '== uses type coercion: "5" is coerced to 5, so "5" == 5 is true.', 2),
  ('dev-q03', '"5" === 5 in JavaScript returns:', '["true","false","Error","undefined"]', 1, '=== requires same type: string "5" !== number 5.', 3),
  ('dev-q03', 'What does % do?', '["Division","Power","Remainder (modulo)","Percentage"]', 2, '% is the modulo operator: 10 % 3 = 1 (the remainder after division).', 4),
  ('dev-q03', 'What does ** do?', '["Multiply by 2","Exponentiation (power)","Bitwise AND","String repeat"]', 1, '** is the exponentiation operator: 2 ** 3 = 8 (2 to the power 3).', 5),
  ('dev-q03', 'x++ is:', '["Decrement x by 1","Add 1 to x and return NEW value","Return x then add 1","Multiply x by 2"]', 2, 'x++ (post-increment) returns x''s current value, then increments it.', 6),
  ('dev-q03', 'What does the && operator mean?', '["OR — true if either is true","AND — true only if both are true","NOT — inverts the value","XOR"]', 1, '&& is logical AND: both conditions must be true for the result to be true.', 7),
  ('dev-q03', 'What does ! (exclamation) do in JavaScript?', '["String concatenation","Logical NOT — inverts boolean","Factorial","Strict comparison"]', 1, '! is the logical NOT operator: !true === false, !false === true.', 8),
  ('dev-q03', 'The ternary operator syntax is:', '["if ? then : else","condition ? valueIfTrue : valueIfFalse","value if condition else other","(condition) => value"]', 1, 'Ternary: condition ? trueValue : falseValue. A compact if/else.', 9),
  ('dev-q03', 'What does += do?', '["Add then compare","Assign and increment: x += 5 means x = x + 5","Check if greater or equal","Concatenate strings only"]', 1, '+= is shorthand: x += 5 is the same as x = x + 5.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q04: Conditionals
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q04', 'Which values are "falsy" in JavaScript?', '["0, false, null, undefined, NaN, ''''","0, false, null","false and null only","Empty string only"]', 0, 'Falsy values: 0, false, null, undefined, NaN, "" (empty string). All others are truthy.', 1),
  ('dev-q04', 'What is the correct if/else syntax?', '["if condition { } else { }","if (condition) { } else { }","if [condition] { } else { }","if condition then { } else { }"]', 1, 'if (condition) { } else { } is the correct JavaScript syntax.', 2),
  ('dev-q04', 'else if allows you to:', '["Nest else blocks","Check multiple conditions in sequence","Use else without if","Combine loops and conditions"]', 1, 'else if chains multiple conditions, checked in order.', 3),
  ('dev-q04', 'A switch statement is useful when:', '["You need loops","You have many comparisons against the same variable","You need to compare two variables","You have nested conditions"]', 1, 'switch is clean when comparing one variable against many possible values.', 4),
  ('dev-q04', 'What does break do in a switch?', '["Exits the loop","Skips to next case","Exits the switch block","Causes an error"]', 2, 'break exits the switch block; without it, code "falls through" to the next case.', 5),
  ('dev-q04', 'A default case in switch:', '["Is required","Runs if no other case matches","Replaces else","Runs first"]', 1, 'default is like else — it runs when no other case matches.', 6),
  ('dev-q04', 'What does this return: 10 > 5 ? "yes" : "no"', '["yes","no","true","10"]', 0, '10 > 5 is true, so the ternary returns "yes".', 7),
  ('dev-q04', 'Short-circuit evaluation in: false && doSomething()', '["doSomething() is called","doSomething() is NOT called","Causes an error","Returns true"]', 1, 'With &&, if the left side is false, the right side is never evaluated.', 8),
  ('dev-q04', 'The nullish coalescing operator ?? returns:', '["The left side always","The right side if left is null or undefined, otherwise left","The right side always","Left side if right is truthy"]', 1, '?? returns the right side only when the left side is null or undefined.', 9),
  ('dev-q04', 'Optional chaining ?. is used to:', '["Create optional parameters","Safely access nested properties that might not exist","Check if a value is null","Compare with null"]', 1, 'user?.address?.city safely returns undefined instead of throwing an error.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q05: Loops
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q05', 'A for loop syntax is:', '["for (init; condition; update) {}","for init to end {}","loop (condition) {}","repeat (n) {}"]', 0, 'for (let i = 0; i < 10; i++) { } is the standard for loop.', 1),
  ('dev-q05', 'What does break do in a loop?', '["Pauses the loop","Skips current iteration","Exits the loop immediately","Restarts the loop"]', 2, 'break exits the entire loop immediately.', 2),
  ('dev-q05', 'What does continue do in a loop?', '["Exits the loop","Pauses for 1 second","Skips the rest of the current iteration and goes to next","Restarts the loop"]', 2, 'continue skips the rest of the current iteration and moves to the next one.', 3),
  ('dev-q05', 'A while loop runs:', '["A fixed number of times","As long as the condition is true","Once","Forever always"]', 1, 'while (condition) { } keeps looping as long as the condition is true.', 4),
  ('dev-q05', 'A do...while loop:', '["Runs at least once before checking the condition","Checks condition first","Is the same as while","Runs exactly twice"]', 0, 'do { } while (condition) runs the body ONCE before checking the condition.', 5),
  ('dev-q05', 'for...of is used to:', '["Loop over object keys","Loop over iterable values (arrays, strings)","Create a new array","Loop a fixed number of times"]', 1, 'for (const item of array) iterates over the values of an iterable.', 6),
  ('dev-q05', 'for...in is used to:', '["Loop over array values","Loop over object keys","Filter arrays","Loop over characters"]', 1, 'for (const key in object) iterates over the enumerable properties (keys) of an object.', 7),
  ('dev-q05', 'An infinite loop occurs when:', '["The loop runs 1000 times","The condition never becomes false","break is used","continue is used"]', 1, 'If the loop condition never becomes false, the loop runs forever (infinite loop).', 8),
  ('dev-q05', 'forEach() method on an array:', '["Returns a new array","Runs a function for each element, returns undefined","Filters elements","Sorts the array"]', 1, 'forEach runs a callback for each element; it doesn''t return anything.', 9),
  ('dev-q05', 'for (let i = 0; i < 5; i++) runs the loop body:', '["4 times","5 times","6 times","0 times"]', 1, 'i starts at 0, runs while i < 5 (0,1,2,3,4), so 5 iterations.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q06: Functions
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q06', 'A function declaration syntax is:', '["function name() {}","def name() {}","fn name() {}","func name() {}"]', 0, 'function name() { } is the function declaration syntax in JavaScript.', 1),
  ('dev-q06', 'Parameters are:', '["The values returned by a function","Variables listed in the function definition","The function name","The function body"]', 1, 'Parameters are the named variables in the function definition (placeholders).', 2),
  ('dev-q06', 'Arguments are:', '["Variables in function definition","The actual values passed when calling the function","The return value","The function body"]', 1, 'Arguments are the actual values you pass when calling the function.', 3),
  ('dev-q06', 'The return statement:', '["Prints a value","Exits the function and optionally sends a value back","Starts the function","Repeats the function"]', 1, 'return exits the function and sends a value back to the caller.', 4),
  ('dev-q06', 'Arrow function syntax:', '["(params) => {}","function => {}","params -> {}","=> (params) {}"]', 0, 'Arrow functions: (params) => { body } or params => expression', 5),
  ('dev-q06', 'A pure function:', '["Uses global variables","Has side effects","Given the same input, always returns the same output with no side effects","Changes the DOM"]', 2, 'Pure functions are predictable, testable, and have no side effects.', 6),
  ('dev-q06', 'Default parameters allow:', '["Multiple return values","Parameters with fallback values if not provided","Functions without parameters","Infinite parameters"]', 1, 'function greet(name = "World") { } uses "World" if name is not provided.', 7),
  ('dev-q06', 'The rest parameter (...args) collects:', '["The first argument","The last argument","All remaining arguments into an array","A fixed number of arguments"]', 2, '...args collects all remaining arguments passed after defined parameters.', 8),
  ('dev-q06', 'Function hoisting means:', '["Functions are moved to the bottom","Function declarations are moved to top of scope at runtime","Functions become available only after declaration","Functions are deleted after use"]', 1, 'Function declarations are hoisted — you can call them before they appear in code.', 9),
  ('dev-q06', 'A callback function is:', '["A function that calls itself","A function passed as an argument to another function","A function that returns a function","A named function"]', 1, 'Callbacks are functions passed as arguments to be called later (e.g., in setTimeout).', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q07: Arrays
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q07', 'Arrays in JavaScript are:', '["Fixed size","Zero-indexed (first element is index 0)","One-indexed (first element is index 1)","All the same type"]', 1, 'JavaScript arrays start at index 0: arr[0] is the first element.', 1),
  ('dev-q07', 'arr.push(item) does:', '["Removes the last item","Adds item to the beginning","Adds item to the end, returns new length","Returns the array"]', 2, 'push() adds to the END of an array and returns the new length.', 2),
  ('dev-q07', 'arr.pop() does:', '["Removes and returns the first item","Removes and returns the last item","Adds to the end","Clears the array"]', 1, 'pop() removes and returns the LAST element of an array.', 3),
  ('dev-q07', 'arr.shift() does:', '["Removes last item","Adds to start","Removes and returns first item","Sorts the array"]', 2, 'shift() removes and returns the FIRST element (opposite of pop).', 4),
  ('dev-q07', 'arr.length gives:', '["Index of last element","Number of elements in the array","The first element","The last element"]', 1, 'arr.length returns the count of elements. Last index = arr.length - 1.', 5),
  ('dev-q07', 'arr.slice(1, 3) returns:', '["Elements at index 1 and 3","Elements from index 1 to 2 (not including 3)","Elements from index 1 to 3","Elements before index 1"]', 1, 'slice(start, end) returns elements from start UP TO BUT NOT INCLUDING end.', 6),
  ('dev-q07', 'arr.splice(1, 2) does:', '["Splits into 2 arrays","Removes 2 elements starting at index 1, modifying original","Returns elements 1 and 2","Inserts at index 1"]', 1, 'splice(index, count) removes count elements at index from the original array.', 7),
  ('dev-q07', 'The spread operator [...arr] is used to:', '["Delete an array","Create a shallow copy or spread elements","Reverse an array","Sort an array"]', 1, '...arr spreads elements. [...arr] creates a shallow copy. [...a, ...b] merges arrays.', 8),
  ('dev-q07', 'Array destructuring: const [a, b] = [1, 2, 3] gives:', '["a=1, b=2","a=[1,2], b=[3]","a=1, b=[2,3]","Error"]', 0, 'Destructuring unpacks: a gets 1, b gets 2. The 3 is ignored.', 9),
  ('dev-q07', 'arr.includes(value) returns:', '["The index of value","true if value is in array, false otherwise","The count of value","A new array"]', 1, 'includes() returns a boolean: true if the value exists in the array.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q08: Objects
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q08', 'JavaScript objects store:', '["Only strings","Only numbers","Key-value pairs","Ordered lists"]', 2, 'Objects store key-value pairs: { name: "Alex", age: 10 }', 1),
  ('dev-q08', 'To access obj.name, you can also use:', '["obj(name)","obj[''name'']","obj->name","obj::name"]', 1, 'Bracket notation obj["name"] works like dot notation obj.name.', 2),
  ('dev-q08', 'Object.keys(obj) returns:', '["All values","All key-value pairs","All keys as an array","The number of keys"]', 2, 'Object.keys() returns an array of the object''s own enumerable property names.', 3),
  ('dev-q08', 'Object destructuring: const { name, age } = person gives:', '["An array of name and age","Variables name and age from person object","A copy of person","name and age as strings"]', 1, 'Destructuring extracts properties into variables: name = person.name, age = person.age.', 4),
  ('dev-q08', 'Spread syntax with objects: { ...obj1, ...obj2 } creates:', '["An array","A merged object combining both","A reference to obj1","An error if keys overlap"]', 1, 'Object spread merges properties. Later keys overwrite earlier ones if they match.', 5),
  ('dev-q08', 'The this keyword inside a method refers to:', '["The global object","The function","The object the method belongs to","The parent object"]', 2, 'Inside an object method, this refers to the object the method is called on.', 6),
  ('dev-q08', 'To add a new property to obj:', '["obj.newProp = value","obj.add(''newProp'', value)","obj[''newProp''].create()","obj.create(''newProp'', value)"]', 0, 'Simply assign: obj.newProp = value or obj["newProp"] = value.', 7),
  ('dev-q08', 'delete obj.property:', '["Hides the property","Removes the property from the object","Sets it to null","Sets it to undefined"]', 1, 'delete removes the property entirely from the object.', 8),
  ('dev-q08', '"key" in obj returns:', '["The value of key","true if key exists in obj","The index of key","An error if key does not exist"]', 1, 'The in operator returns true if the property exists in the object (or prototype chain).', 9),
  ('dev-q08', 'Object.freeze(obj) means:', '["The object is deleted","No new properties can be added and existing ones cannot change","The object becomes null","Properties become undefined"]', 1, 'Object.freeze() prevents any changes to the object — adding, removing, or modifying.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q09: DOM
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q09', 'DOM stands for:', '["Document Object Model","Document Orientation Management","Dynamic Object Model","Data Object Mapping"]', 0, 'DOM = Document Object Model — the tree representation of an HTML page in JavaScript.', 1),
  ('dev-q09', 'document.getElementById("id") returns:', '["All elements with that id","The first element with that id","An array of elements","null always"]', 1, 'getElementById returns the single element matching that id (or null if not found).', 2),
  ('dev-q09', 'document.querySelector(".card") returns:', '["All elements with class card","The first element matching the selector","An array","All elements"]', 1, 'querySelector returns the FIRST element matching the CSS selector.', 3),
  ('dev-q09', 'document.querySelectorAll("p") returns:', '["The first paragraph","A NodeList of all matching elements","An array","The last paragraph"]', 1, 'querySelectorAll returns a NodeList of ALL matching elements.', 4),
  ('dev-q09', 'To change text content of an element:', '["el.text = ''new''","el.innerHTML = ''new''","el.textContent = ''new''","el.change(''new'')"]', 2, 'textContent sets text safely (no HTML parsing). innerHTML parses HTML.', 5),
  ('dev-q09', 'Why use textContent instead of innerHTML for user input?', '["textContent is faster","innerHTML can execute malicious scripts (XSS risk)","textContent supports HTML tags","There is no difference"]', 1, 'innerHTML treats content as HTML, risking XSS attacks with user-supplied data.', 6),
  ('dev-q09', 'el.classList.add("active") does:', '["Removes all classes","Adds active class to element","Checks if class exists","Removes active class"]', 1, 'classList.add() adds a CSS class to the element without removing existing classes.', 7),
  ('dev-q09', 'el.classList.toggle("open") does:', '["Always adds open","Always removes open","Adds open if absent, removes if present","Checks if open exists"]', 2, 'toggle() adds the class if it''s not there, removes it if it is.', 8),
  ('dev-q09', 'To create a new element:', '["new Element(''div'')","document.createElement(''div'')","document.new(''div'')","createElement(''div'')"]', 1, 'document.createElement(tagName) creates a new DOM element.', 9),
  ('dev-q09', 'el.appendChild(child) does:', '["Removes child from el","Inserts child as the first child of el","Appends child as the last child of el","Replaces el with child"]', 2, 'appendChild adds the new element as the last child of the parent.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q10: Events
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q10', 'addEventListener() is used to:', '["Create HTML elements","Listen for and respond to events","Remove event listeners","Create CSS animations"]', 1, 'addEventListener(event, callback) attaches an event handler to an element.', 1),
  ('dev-q10', 'The first argument to addEventListener is:', '["The callback function","The event type (e.g., ''click'')","The element","The event object"]', 1, 'First arg is the event type as a string: "click", "submit", "keydown", etc.', 2),
  ('dev-q10', 'event.preventDefault() is used to:', '["Stop event bubbling","Prevent the default browser behaviour (like form submission)","Remove the event listener","Stop all events"]', 1, 'e.preventDefault() stops the browser''s default action, like form submission or link navigation.', 3),
  ('dev-q10', 'Event bubbling means:', '["Events go from child to parent up the DOM","Events go from parent to child","Events are cancelled","Events repeat"]', 0, 'When an event fires, it bubbles up through parent elements unless stopped.', 4),
  ('dev-q10', 'event.stopPropagation() does:', '["Prevents default browser action","Stops event from bubbling to parent elements","Removes the listener","Logs the event"]', 1, 'stopPropagation() stops the event from bubbling up to parent elements.', 5),
  ('dev-q10', 'Which event fires when a form is submitted?', '["click","submit","change","input"]', 1, 'The "submit" event fires when a form is submitted.', 6),
  ('dev-q10', 'Which event fires when a key is pressed down?', '["keypress","keyup","keydown","keystroke"]', 2, '"keydown" fires as soon as a key is pressed down.', 7),
  ('dev-q10', 'The event.target property refers to:', '["The element the listener is on","The element that actually triggered the event","The parent element","The document"]', 1, 'event.target is the element that was actually interacted with (may be a child).', 8),
  ('dev-q10', 'DOMContentLoaded event fires when:', '["The page fully loads including images","The HTML is parsed and DOM is ready","JavaScript executes","CSS is loaded"]', 1, 'DOMContentLoaded fires when HTML is parsed, without waiting for images/styles.', 9),
  ('dev-q10', 'Event delegation means:', '["Each element gets its own listener","Adding a listener to a parent to handle events from children","Removing all event listeners","Preventing event bubbling"]', 1, 'Event delegation uses bubbling: add one listener to parent instead of many to children.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Bulk insert for remaining quizzes (Q11-Q50) with placeholder questions
-- Each gets 10 structured questions
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id,
  'Question ' || s::text || ' for ' || q.title,
  '["Option A (correct)","Option B","Option C","Option D"]',
  0,
  'This question tests your knowledge of ' || q.category || '. Study the ' || q.category || ' lessons to master this topic.',
  10,
  s
FROM quizzes q
CROSS JOIN generate_series(1, 10) s
WHERE q.slug IN (
  'dev-q11','dev-q12','dev-q13','dev-q14','dev-q15','dev-q16','dev-q17','dev-q18','dev-q19','dev-q20',
  'dev-q21','dev-q22','dev-q23','dev-q24','dev-q25','dev-q26','dev-q27','dev-q28','dev-q29','dev-q30',
  'dev-q31','dev-q32','dev-q33','dev-q34','dev-q35','dev-q36','dev-q37','dev-q38','dev-q39','dev-q40',
  'dev-q41','dev-q42','dev-q43','dev-q44','dev-q45','dev-q46','dev-q47','dev-q48','dev-q49','dev-q50'
)
ON CONFLICT DO NOTHING;
