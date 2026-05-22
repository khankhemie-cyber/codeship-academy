-- =============================================================================
-- CODEship Academy — Developers Quizzes Q11–Q30: Full Questions
-- Replaces placeholder content for dev-q11 through dev-q30
-- Target: Ages 11–14 | JavaScript, Python
-- =============================================================================

-- Q11: String Methods Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q11', 'What does "hello".slice(1, 3) return?', '["hel","el","ell","lo"]', 1, 'slice(start, end) extracts characters from index 1 up to (but not including) index 3, giving "el".', 1),
  ('dev-q11', 'What does "hello world".indexOf("world") return?', '["0","5","6","true"]', 2, 'indexOf() returns the starting index of the first match. "world" begins at index 6.', 2),
  ('dev-q11', 'What does "javascript".includes("script") return?', '["0","5","true","false"]', 2, 'includes() returns true if the substring is found anywhere in the string.', 3),
  ('dev-q11', 'What does "hello".startsWith("hel") return?', '["true","false","0","hel"]', 0, 'startsWith() returns true if the string begins with the given prefix.', 4),
  ('dev-q11', 'What does "goodbye".endsWith("bye") return?', '["true","false","3","bye"]', 0, 'endsWith() returns true if the string ends with the given suffix.', 5),
  ('dev-q11', 'What does "ha".repeat(3) return?', '["ha ha ha","hahaha","ha3","hahaHA"]', 1, 'repeat(n) returns a new string with the original repeated n times: "hahaha".', 6),
  ('dev-q11', 'What does "5".padStart(3, "0") return?', '["005","500","5  ","055"]', 0, 'padStart(targetLength, padString) pads the start until the string reaches the target length: "005".', 7),
  ('dev-q11', 'What does "a,b,c".split(",") return?', '["""a,b,c""","[''a'', ''b'', ''c'']","[''a,b'', ''c'']","[''a'',''bc'']"]', 1, 'split() divides a string into an array at each separator: [''a'', ''b'', ''c''].', 8),
  ('dev-q11', 'What does "hello world".replace("world", "JS") return?', '["hello world","hello JS","JS world","helloJS"]', 1, 'replace(search, replacement) replaces the first match. Only the first occurrence is replaced.', 9),
  ('dev-q11', 'What is the output of: `My name is ${name}` when name = "Alex"?', '["My name is ${name}","My name is Alex","${name}","My name is"]', 1, 'Template literals use backticks and ${} to embed expressions directly into strings.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q12: Array Methods Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q12', '[1, 2, 3].map(x => x * 2) returns:', '["[1,2,3]","[2,4,6]","6","[2,3,4]"]', 1, 'map() creates a NEW array by running a function on every element: [2, 4, 6].', 1),
  ('dev-q12', '[1, 2, 3, 4].filter(x => x > 2) returns:', '["[1,2]","[3,4]","[2,3,4]","[1,2,3]"]', 1, 'filter() returns a new array with only elements that pass the test: [3, 4].', 2),
  ('dev-q12', '[1, 2, 3].reduce((acc, x) => acc + x, 0) returns:', '["[1,2,3]","6","0","3"]', 1, 'reduce() accumulates values into one. Starting at 0: 0+1+2+3 = 6.', 3),
  ('dev-q12', '[5, 12, 8].find(x => x > 10) returns:', '["[12]","12","true","undefined"]', 1, 'find() returns the FIRST element that passes the test: 12. (Not an array, just the value.)', 4),
  ('dev-q12', '[5, 12, 8].findIndex(x => x > 10) returns:', '["0","1","2","true"]', 1, 'findIndex() returns the INDEX of the first matching element. 12 is at index 1.', 5),
  ('dev-q12', '[1, 2, 3].some(x => x > 2) returns:', '["[3]","false","true","3"]', 2, 'some() returns true if AT LEAST ONE element passes the test. 3 > 2, so true.', 6),
  ('dev-q12', '[2, 4, 6].every(x => x % 2 === 0) returns:', '["false","true","[2,4,6]","3"]', 1, 'every() returns true only if ALL elements pass the test. All are even, so true.', 7),
  ('dev-q12', '[[1, 2], [3, 4]].flat() returns:', '["[[1,2],[3,4]]","[1,2,3,4]","[1,2],[3,4]","[3,4]"]', 1, 'flat() flattens one level of nested arrays into a single array: [1, 2, 3, 4].', 8),
  ('dev-q12', '[1, 2, 3].flatMap(x => [x, x * 2]) returns:', '["[[1,2],[2,4],[3,6]]","[1,2,2,4,3,6]","[2,4,6]","[1,2,3]"]', 1, 'flatMap() maps then flattens one level: each element becomes [x, x*2], then flattened.', 9),
  ('dev-q12', 'Array.from("abc") returns:', '["abc","[''abc'']","[''a'',''b'',''c'']","[97,98,99]"]', 2, 'Array.from() creates an array from an iterable. "abc" becomes [''a'', ''b'', ''c''].', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q13: Math and Numbers Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q13', 'Math.round(4.6) returns:', '["4","5","4.6","6"]', 1, 'Math.round() rounds to the nearest integer. 4.6 rounds UP to 5.', 1),
  ('dev-q13', 'Math.floor(4.9) returns:', '["5","4","4.9","3"]', 1, 'Math.floor() always rounds DOWN: 4.9 becomes 4.', 2),
  ('dev-q13', 'Math.ceil(4.1) returns:', '["4","5","4.1","3"]', 1, 'Math.ceil() always rounds UP: 4.1 becomes 5.', 3),
  ('dev-q13', 'Math.max(3, 7, 2, 9, 1) returns:', '["3","1","9","7"]', 2, 'Math.max() returns the largest of the provided numbers: 9.', 4),
  ('dev-q13', 'parseInt("42px") returns:', '["NaN","42px","42","0"]', 2, 'parseInt() parses the integer at the start of a string, ignoring trailing non-numeric characters.', 5),
  ('dev-q13', 'What is NaN?', '["A type of number","The result of invalid math like 0/0 or parseInt(\"abc\")","Null and Nil","Negative Any Number"]', 1, 'NaN (Not a Number) is the result of invalid numeric operations like parseInt("abc").', 6),
  ('dev-q13', 'isNaN("hello") returns:', '["false","true","null","undefined"]', 1, 'isNaN() returns true when the value cannot be converted to a valid number.', 7),
  ('dev-q13', 'Number("3.14") returns:', '["NaN","\"3.14\"","3","3.14"]', 3, 'Number() converts a string to a number. "3.14" becomes the number 3.14.', 8),
  ('dev-q13', 'Math.random() returns:', '["A random integer","A random float between 0 (inclusive) and 1 (exclusive)","A random number between 1 and 10","Always 0.5"]', 1, 'Math.random() returns a float like 0.472... Use Math.floor(Math.random() * 10) for integers.', 9),
  ('dev-q13', '(3.14159).toFixed(2) returns:', '["3","3.14","\"3.14\"","3.1"]', 2, 'toFixed(n) returns a STRING with n decimal places: "3.14". Note: it returns a string!', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q14: Error Handling Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q14', 'The correct syntax for try/catch is:', '["try {} then catch {}","try {} catch(e) {}","attempt {} handle {}","try: except:"]', 1, 'try { } catch(error) { } is the correct JavaScript error handling syntax.', 1),
  ('dev-q14', 'A TypeError occurs when:', '["A variable is not defined","You use a value in the wrong way, like calling undefined as a function","The JSON is invalid","A file is missing"]', 1, 'TypeError: null.property, calling a non-function, using wrong data types.', 2),
  ('dev-q14', 'A ReferenceError occurs when:', '["You divide by zero","You access a variable that has not been declared","A property is missing","Syntax is wrong"]', 1, 'ReferenceError: accessing a variable that does not exist in the current scope.', 3),
  ('dev-q14', 'A SyntaxError occurs when:', '["Runtime logic fails","Code is grammatically invalid — JavaScript cannot parse it","A number is NaN","A file is missing"]', 1, 'SyntaxError: missing bracket, invalid JSON, wrong syntax. Caught before code even runs.', 4),
  ('dev-q14', 'The finally block:', '["Only runs if an error occurs","Only runs if no error occurs","Always runs, whether or not an error occurred","Runs before try"]', 2, 'finally always runs — great for cleanup like closing connections regardless of success or failure.', 5),
  ('dev-q14', 'The throw keyword is used to:', '["Catch an error","Create and throw your own error","Log an error","Ignore an error"]', 1, 'throw lets you create custom errors: throw new Error("Something went wrong");', 6),
  ('dev-q14', 'To throw a custom error:', '["throw \"error\"","throw new Error(\"message\")","error.throw(\"message\")","raise Error(\"message\")"]', 1, 'throw new Error("message") creates and throws an Error object with a message.', 7),
  ('dev-q14', 'error.message gives you:', '["The error type","The human-readable description of the error","The line number","The file name"]', 1, 'error.message contains the string description passed when the error was created.', 8),
  ('dev-q14', 'error.name gives you:', '["The variable name","The type of error, like \"TypeError\" or \"ReferenceError\"","The file name","The function name"]', 1, 'error.name is the error type: "Error", "TypeError", "ReferenceError", etc.', 9),
  ('dev-q14', 'Why is catching all errors silently (empty catch block) bad practice?', '["It slows the code down","Errors are hidden, making bugs very hard to find and fix","It uses more memory","It is not valid JavaScript"]', 1, 'Swallowing errors silently means you never know something went wrong — always log or handle errors.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q15: Scope and Closures Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q15', 'var declared inside an if block is accessible:', '["Only inside the if block","Only in the function the if is in","Nowhere outside the line","Only inside loops"]', 1, 'var has function scope, not block scope — it leaks out of if/for blocks into the enclosing function.', 1),
  ('dev-q15', 'let declared inside an if block is accessible:', '["Anywhere in the function","Only inside that if block","Globally","Inside any nested block"]', 1, 'let has block scope — it is only accessible within the { } block it was declared in.', 2),
  ('dev-q15', 'Variable hoisting with var means:', '["var variables cannot be used","var declarations are moved to the top of their scope before code runs","var is deprecated","var values are pre-set to 0"]', 1, 'Hoisting moves var declarations (not assignments) to the top, so the variable exists but is undefined.', 3),
  ('dev-q15', 'Accessing a let variable before its declaration causes:', '["undefined","0","ReferenceError (Temporal Dead Zone)","null"]', 2, 'let and const have a Temporal Dead Zone — accessing them before declaration throws a ReferenceError.', 4),
  ('dev-q15', 'A closure is when:', '["A function returns nothing","An inner function remembers variables from its outer function''s scope","A function calls itself","A variable is deleted"]', 1, 'Closures let inner functions access outer variables even after the outer function has finished running.', 5),
  ('dev-q15', 'What does this closure return? function outer() { let x = 10; return function() { return x; } }', '["undefined","ReferenceError","10","null"]', 2, 'The inner function closes over x from outer(). It remembers x = 10 and returns it.', 6),
  ('dev-q15', 'A practical use of closures is:', '["Sorting arrays","Creating private variables that cannot be accessed from outside","Checking types","Parsing JSON"]', 1, 'Closures create private state — a counter that only the returned function can increment, for example.', 7),
  ('dev-q15', 'An IIFE (Immediately Invoked Function Expression) looks like:', '["function run() {}","(function() { })()","function()()","invoke(function() {})"]', 1, 'An IIFE is defined and called immediately: (function() { /* code */ })(). Useful for encapsulation.', 8),
  ('dev-q15', 'The Temporal Dead Zone (TDZ) affects:', '["var only","let and const","All variables","Only const"]', 1, 'Only let and const have a TDZ. var is hoisted and initialized to undefined.', 9),
  ('dev-q15', 'Global scope means:', '["Only accessible inside functions","Accessible from anywhere in the program","Only in the browser console","Only in strict mode"]', 1, 'Global variables are declared outside all functions and are accessible everywhere — use sparingly.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q16: ES6+ Features Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q16', 'Which keyword should you use for a variable that will NEVER be reassigned?', '["var","let","const","fix"]', 2, 'const declares a constant binding. Use const by default, let when you need to reassign.', 1),
  ('dev-q16', 'Arrow functions differ from regular functions because:', '["They are faster","They do not have their own this binding","They cannot have parameters","They always return undefined"]', 1, 'Arrow functions inherit this from their enclosing scope — they don''t create their own this.', 2),
  ('dev-q16', 'Template literals use:', '["Single quotes ''","Double quotes \"","Backticks `","Square brackets ["]', 2, 'Template literals use backticks ` ` and allow embedded expressions with ${}.', 3),
  ('dev-q16', 'Array destructuring: const [first, , third] = [1, 2, 3]. What is third?', '["1","2","3","undefined"]', 2, 'The empty comma skips index 1. third captures index 2, which is 3.', 4),
  ('dev-q16', 'The spread operator (...) can be used to:', '["Only copy arrays","Spread iterable elements into another array, object, or function call","Only spread objects","Only spread strings"]', 1, 'Spread unpacks elements: Math.max(...[3,1,4]) or merging objects with {...obj1, ...obj2}.', 5),
  ('dev-q16', 'Default parameters: function greet(name = "World"). What is name if called as greet()?', '["undefined","null","\"World\"","\"name\""]', 2, 'If no argument is provided, the default value "World" is used automatically.', 6),
  ('dev-q16', 'Object shorthand: if a variable is named score, you can write:', '["{ score: score }","{ score }","{ score() }","{ :score }"]', 1, 'Property shorthand: when the key and variable name match, just write { score } instead of { score: score }.', 7),
  ('dev-q16', 'user?.address?.city uses optional chaining. If address is undefined, this returns:', '["Error","null","undefined","\"city\""]', 2, 'Optional chaining (?.) returns undefined instead of throwing a TypeError when a property does not exist.', 8),
  ('dev-q16', 'let name = null; let display = name ?? "Guest". What is display?', '["null","\"name\"","\"Guest\"","undefined"]', 2, 'Nullish coalescing (??) returns the right side only when the left is null or undefined. Result: "Guest".', 9),
  ('dev-q16', 'Computed property names allow:', '["Dynamic property values","Using a variable as a property name: { [varName]: value }","Array-style access","Nested objects only"]', 1, '{ [dynamicKey]: value } lets you use an expression as an object key at creation time.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q17: Async JavaScript Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q17', 'Synchronous code executes:', '["In parallel","One line at a time, in order, waiting for each to finish","Only in the browser","Without any delay"]', 1, 'Synchronous code blocks: each line must finish before the next one starts.', 1),
  ('dev-q17', 'Asynchronous code allows:', '["Faster computers","Starting a task and continuing without waiting for it to finish","Running on multiple CPUs","Skipping code"]', 1, 'Async lets long tasks (fetching data, timers) run in the background while other code continues.', 2),
  ('dev-q17', 'A callback function is:', '["The first function you write","A function passed to another function to be called later","A function that returns a value","An arrow function"]', 1, 'Callbacks are the traditional way to handle async: pass a function to be called when the task finishes.', 3),
  ('dev-q17', 'A Promise has three possible states:', '["open, closed, done","waiting, done, failed","pending, fulfilled, rejected","start, running, end"]', 1, 'Promises are: pending (in progress), fulfilled (success), or rejected (failed).', 4),
  ('dev-q17', '.then() on a Promise runs:', '["When the Promise is rejected","When the Promise is fulfilled (resolved)","Always immediately","When the page loads"]', 1, '.then(callback) runs the callback with the resolved value when the Promise succeeds.', 5),
  ('dev-q17', '.catch() on a Promise runs:', '["When it succeeds","When the Promise is rejected (fails)","Always","Before .then()"]', 1, '.catch(callback) handles the error when a Promise rejects.', 6),
  ('dev-q17', 'Promise.all([p1, p2, p3]) resolves when:', '["The first Promise resolves","All Promises resolve","One rejects","Any one resolves"]', 0, 'Promise.all() waits for ALL promises to resolve. If any rejects, the whole thing rejects.', 7),
  ('dev-q17', 'Promise.race([p1, p2]) resolves/rejects when:', '["All complete","The fastest Promise settles (resolves or rejects) first","Only if all succeed","Only if both fail"]', 1, 'Promise.race() settles as soon as the first Promise in the array settles.', 8),
  ('dev-q17', 'async/await is:', '["A new type of loop","Syntax sugar over Promises that makes async code look synchronous","A browser API","A replacement for try/catch"]', 1, 'async/await makes Promise-based code easier to read and write — it still uses Promises underneath.', 9),
  ('dev-q17', 'Microtasks (Promise callbacks) run:', '["After all setTimeout callbacks","Before the next macrotask, after the current task finishes","At random times","Only when the page is idle"]', 1, 'Microtasks have higher priority than macrotasks — Promise .then() callbacks run before setTimeout callbacks.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q18: Fetch API Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q18', 'fetch() returns:', '["The data directly","A Promise that resolves to a Response object","An array","null"]', 1, 'fetch() is asynchronous and returns a Promise. You need .then() or await to get the response.', 1),
  ('dev-q18', 'To read JSON from a fetch response, you call:', '["response.text()","response.data","response.json()","JSON.parse(response)"]', 2, 'response.json() also returns a Promise that resolves to the parsed JavaScript object.', 2),
  ('dev-q18', 'A GET request with fetch looks like:', '["fetch.get(url)","fetch(url)","fetch(url, { method: ''GET'' })","Both B and C"]', 3, 'fetch(url) makes a GET request by default. You can also explicitly set { method: ''GET'' }.', 3),
  ('dev-q18', 'To send a POST request with fetch, you need:', '["fetch.post(url, data)","fetch(url, { method: ''POST'', body: JSON.stringify(data) })","post(url, data)","fetch.send(url, data)"]', 1, 'POST needs method: "POST", headers with Content-Type, and body with JSON.stringify(data).', 4),
  ('dev-q18', 'response.ok is true when the status code is:', '["Any status","200–299 (success range)","Only 200","404 or 500"]', 1, 'response.ok returns true for HTTP status codes 200–299 (successful responses).', 5),
  ('dev-q18', 'A 404 status code means:', '["Server error","Not Found — the requested resource does not exist","Success","Unauthorized"]', 1, '404 Not Found means the URL does not point to an existing resource on the server.', 6),
  ('dev-q18', 'CORS stands for:', '["Code Object Request Syntax","Cross-Origin Resource Sharing","Client Object Response System","Cross-Origin Request Script"]', 1, 'CORS is a browser security feature controlling which domains can request your API.', 7),
  ('dev-q18', 'Using async/await with fetch looks like:', '["const data = await fetch(url).json()","const res = await fetch(url); const data = await res.json()","const data = fetch.async(url)","await.fetch(url)"]', 1, 'You must await fetch() first to get the response, then await response.json() to parse it.', 8),
  ('dev-q18', 'What should you always do when fetch() might fail?', '["Nothing","Wrap in try/catch or chain .catch()","Use a loop","Check typeof"]', 1, 'Network errors and non-ok responses need error handling with try/catch or .catch().', 9),
  ('dev-q18', 'The Content-Type header "application/json" tells the server:', '["The file size","The request body contains JSON data","The response is HTML","The language of the page"]', 1, 'Setting Content-Type: application/json informs the server how to parse the request body.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q19: Local Storage Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q19', 'localStorage stores data:', '["Only for the current session","Permanently until cleared by code or the user","For 24 hours only","On the server"]', 1, 'localStorage persists data with no expiration — it survives page refreshes and browser restarts.', 1),
  ('dev-q19', 'sessionStorage stores data:', '["Permanently","Until the browser tab or window is closed","For one hour","On the server"]', 1, 'sessionStorage is cleared when the tab or window is closed — good for temporary session data.', 2),
  ('dev-q19', 'To save a value: localStorage.setItem("score", 100) stores:', '["The number 100","The string \"100\"","An object","null"]', 1, 'localStorage only stores strings! Numbers and booleans are automatically converted to strings.', 3),
  ('dev-q19', 'localStorage.getItem("score") returns:', '["100 (number)","\"100\" (string)","null always","undefined"]', 1, 'getItem returns the stored STRING. Use Number() or parseInt() to convert it back.', 4),
  ('dev-q19', 'To remove one item: localStorage.removeItem("key"). To clear ALL items use:', '["localStorage.deleteAll()","localStorage.clear()","localStorage.reset()","localStorage.remove(\"*\")"]', 1, 'localStorage.clear() removes all key-value pairs stored for that domain.', 5),
  ('dev-q19', 'To store an object in localStorage, you must:', '["Store it directly","Use JSON.stringify() to convert it to a string first","Use Array.from()","Use Object.assign()"]', 1, 'localStorage only stores strings. JSON.stringify converts objects; JSON.parse converts back.', 6),
  ('dev-q19', 'localStorage.getItem("missing") returns:', '["undefined","0","null","false"]', 2, 'If the key does not exist, getItem returns null (not undefined).', 7),
  ('dev-q19', 'The typical storage limit for localStorage is approximately:', '["4KB","5–10MB","1GB","Unlimited"]', 1, 'Most browsers allow about 5–10MB of localStorage per origin.', 8),
  ('dev-q19', 'localStorage vs cookies: a key difference is:', '["Cookies store more data","Cookies can be sent to the server automatically with HTTP requests; localStorage cannot","localStorage expires automatically","There is no difference"]', 1, 'Cookies are sent with every HTTP request automatically. localStorage stays in the browser only.', 9),
  ('dev-q19', 'Which of these is a good use case for localStorage?', '["Storing passwords","Remembering a user''s dark mode preference","Storing credit card numbers","Saving server-side data"]', 1, 'Preferences like theme/language settings are perfect for localStorage. Never store sensitive data!', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q20: JSON Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q20', 'JSON stands for:', '["JavaScript Object Notation","JavaScript Open Network","Java Standard Object Name","JavaScript Online Node"]', 0, 'JSON = JavaScript Object Notation — a lightweight text format for storing and sharing data.', 1),
  ('dev-q20', 'Which of these is VALID JSON?', '["{name: \"Alex\"}","{\"name\": \"Alex\"}","{ name: Alex }","{ \"name\": Alex }"]', 1, 'JSON requires double quotes around both keys and string values. Single quotes are not valid.', 2),
  ('dev-q20', 'JSON.parse(''{"score": 42}'') returns:', '["The string {\"score\": 42}","A JavaScript object { score: 42 }","42","An array"]', 1, 'JSON.parse() converts a JSON string into a JavaScript object you can work with.', 3),
  ('dev-q20', 'JSON.stringify({ name: "Alex", age: 11 }) returns:', '["The object unchanged","A JSON string: \"{\"name\":\"Alex\",\"age\":11}\"","An array","null"]', 1, 'JSON.stringify() converts a JavaScript object into a JSON-formatted string.', 4),
  ('dev-q20', 'Which data type does NOT exist in JSON?', '["string","number","undefined","boolean"]', 2, 'JSON has: string, number, boolean, array, object, null — but NOT undefined.', 5),
  ('dev-q20', 'JSON null vs JavaScript undefined: in JSON you use:', '["undefined","null","false","0"]', 1, 'JSON has null but no undefined. undefined values are stripped when you JSON.stringify() an object.', 6),
  ('dev-q20', 'JSON arrays look like:', '["(1, 2, 3)","[1, 2, 3]","{1, 2, 3}","<1, 2, 3>"]', 1, 'JSON arrays use square brackets with comma-separated values, just like JavaScript arrays.', 7),
  ('dev-q20', 'Nested JSON: {\"user\": {\"name\": \"Sam\"}}. How do you access name after parsing?', '["data[\"user\"][\"name\"]","data.user.name","Both A and B","data.name"]', 2, 'After parsing, you can use either dot notation or bracket notation to access nested properties.', 8),
  ('dev-q20', 'JSON.stringify(obj, null, 2) — what does the 2 do?', '["Limits to 2 properties","Adds 2-space indentation for pretty-printing","Converts to 2 levels deep","Rounds numbers to 2 decimal places"]', 1, 'The third argument is the indentation level for human-readable, formatted JSON output.', 9),
  ('dev-q20', 'A JSON file should have the file extension:', '[".txt",".js",".json",".data"]', 2, 'JSON files use the .json extension. They are plain text files containing valid JSON.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q21: Python Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q21', 'How do you print "Hello" in Python?', '["console.log(\"Hello\")","echo \"Hello\"","print(\"Hello\")","System.out.println(\"Hello\")"]', 2, 'print() is Python''s built-in function for displaying output. No semicolons needed!', 1),
  ('dev-q21', 'Python uses indentation to:', '["Make code look nice","Define code blocks (like the body of if, for, and functions)","Speed up code","Mark comments"]', 1, 'Python replaces curly braces with consistent indentation (usually 4 spaces) to define code blocks.', 2),
  ('dev-q21', 'How do you write a single-line comment in Python?', '["// comment","/* comment */","# comment","-- comment"]', 2, 'Python uses # for comments. Everything after # on that line is ignored by Python.', 3),
  ('dev-q21', 'A key difference between Python 2 and Python 3 is:', '["Python 3 is slower","print is a statement in Python 2 but a function in Python 3","Python 2 has lists","Python 3 cannot divide numbers"]', 1, 'In Python 2: print "hi". In Python 3: print("hi"). Python 3 also has better Unicode support.', 4),
  ('dev-q21', 'type(42) returns:', '["int","integer","number","<class ''int''>"]', 3, 'type() returns the type object: <class ''int''>. You''d see <class ''str''> for strings.', 5),
  ('dev-q21', 'Multiple assignment in Python: a, b, c = 1, 2, 3 means:', '["Only a is set","a=1, b=2, c=3","a=[1,2,3]","Error"]', 1, 'Python supports tuple unpacking: you can assign multiple variables in one line.', 6),
  ('dev-q21', 'The del keyword:', '["Prints a variable","Delays code","Deletes a variable or list element","Declares a variable"]', 2, 'del removes a variable from the namespace or deletes an element from a list.', 7),
  ('dev-q21', 'In Python, True and False are:', '["Strings","Integers (1 and 0)","Boolean values (capitalized)","Keywords meaning yes/no"]', 2, 'Python booleans are True and False (capitalised). bool(1) is True, bool(0) is False.', 8),
  ('dev-q21', 'Python files have the extension:', '[".py",".python",".pyt",".pt"]', 0, 'Python source files use the .py extension.', 9),
  ('dev-q21', 'id(x) in Python returns:', '["The index of x","A unique integer identity (memory address) of the object","The type of x","The length of x"]', 1, 'id() returns a unique integer identifier for an object — its identity in memory.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q22: Python Variables Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q22', 'Which variable name follows Python convention?', '["myVariable","my_variable","MyVariable","my-variable"]', 1, 'Python uses snake_case for variable names: words separated by underscores.', 1),
  ('dev-q22', 'Which variable name is invalid in Python?', '["score","_hidden","2fast","MAX_SIZE"]', 2, 'Variable names cannot start with a digit. 2fast is invalid.', 2),
  ('dev-q22', 'int("42") does:', '["Creates an error","Converts the string \"42\" to the integer 42","Converts to float","Rounds to 42.0"]', 1, 'int() converts strings and floats to integers. int("42") gives 42.', 3),
  ('dev-q22', 'str(100) does:', '["Converts to integer","Converts the number 100 to the string \"100\"","Creates a list","Checks type"]', 1, 'str() converts numbers and other types to their string representation.', 4),
  ('dev-q22', 'float("3.14") does:', '["Error","Converts the string \"3.14\" to the float 3.14","Rounds to 3","Creates a tuple"]', 1, 'float() converts strings and integers to floating-point numbers.', 5),
  ('dev-q22', 'bool(0) returns:', '["True","False","0","None"]', 1, 'bool(0) is False. In Python, 0, empty strings, empty lists, and None are all falsy.', 6),
  ('dev-q22', 'bool("hello") returns:', '["False","True","\"hello\"","None"]', 1, 'Non-empty strings are truthy in Python. bool("hello") is True.', 7),
  ('dev-q22', 'isinstance(42, int) returns:', '["42","True","False","int"]', 1, 'isinstance(value, type) checks if a value is an instance of the given type. 42 is an int, so True.', 8),
  ('dev-q22', 'In Python, variables have no declared type because:', '["Python is untyped","Python is dynamically typed — the type is determined by the value","Python ignores types","All values are strings"]', 1, 'Python is dynamically typed: x = 5 makes x an int; x = "hi" then makes x a str.', 9),
  ('dev-q22', 'CONSTANT_NAME in Python (all caps) means:', '["It is enforced as unchangeable","It is a convention signaling the programmer intends it not to change","It is a reserved keyword","It is a class name"]', 1, 'Python has no true constants — ALL_CAPS is a naming convention telling other developers not to change it.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q23: Python Lists Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q23', 'How do you create an empty list in Python?', '["list{}","()","[]","{}"]', 2, 'Empty lists use square brackets: [] or list(). Curly braces {} make a dict or set.', 1),
  ('dev-q23', 'Given nums = [10, 20, 30], what is nums[1]?', '["10","20","30","IndexError"]', 1, 'Python lists are zero-indexed. Index 1 is the second element: 20.', 2),
  ('dev-q23', 'Given nums = [10, 20, 30], what is nums[-1]?', '["10","20","30","IndexError"]', 2, 'Negative indexing counts from the end. -1 is the last element: 30.', 3),
  ('dev-q23', 'nums = [1, 2, 3, 4, 5]. What is nums[1:4]?', '["[1,2,3]","[2,3,4]","[2,3,4,5]","[1,2,3,4]"]', 1, 'Slicing [1:4] returns elements at index 1, 2, 3 (not including 4): [2, 3, 4].', 4),
  ('dev-q23', 'What is the difference between append() and extend()?', '["No difference","append() adds one item; extend() adds each item from an iterable","extend() adds one item; append() adds multiple","append() modifies; extend() copies"]', 1, 'append([4,5]) adds the list as one item. extend([4,5]) adds 4 and 5 as separate items.', 5),
  ('dev-q23', 'list("abc") returns:', '["[\"abc\"]","[\"a\",\"b\",\"c\"]","abc","Error"]', 1, 'list() with a string creates a list of individual characters: [''a'', ''b'', ''c''].', 6),
  ('dev-q23', 'A nested list looks like:', '["[[1,2],[3,4]]","(1,2,3)","list(list)","[1:2:3]"]', 0, 'Lists can contain other lists: [[1, 2], [3, 4]]. Access inner items with two indices: lst[0][1].', 7),
  ('dev-q23', '[0] * 5 in Python creates:', '["0","[0,1,2,3,4]","[0,0,0,0,0]","Error"]', 2, 'List multiplication repeats elements: [0] * 5 gives [0, 0, 0, 0, 0].', 8),
  ('dev-q23', 'len([1, 2, 3, 4]) returns:', '["3","4","[4]","1"]', 1, 'len() returns the number of items in the list: 4.', 9),
  ('dev-q23', 'To sort a list in place:', '["sorted(lst)","lst.sort()","list.sort(lst)","lst.order()"]', 1, 'lst.sort() sorts the list in place (modifies original). sorted(lst) returns a NEW sorted list.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q24: Python Dictionaries Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q24', 'How do you create a dictionary in Python?', '["[\"name\": \"Alex\"]","(\"name\": \"Alex\")","{ \"name\": \"Alex\" }","dict[\"name\"] = \"Alex\""]', 2, 'Dictionaries use curly braces with key: value pairs: {\"name\": \"Alex\"}.', 1),
  ('dev-q24', 'person = {"name": "Alex", "age": 11}. How do you get the name?', '["person(\"name\")","person[\"name\"]","person.get.name","person->name"]', 1, 'Use square brackets with the key string: person["name"] returns "Alex".', 2),
  ('dev-q24', 'person.get("score") vs person["score"] when "score" does not exist:', '["Both return None","get() returns None; [] raises a KeyError","Both raise KeyError","get() raises KeyError; [] returns None"]', 1, '.get() safely returns None (or a default) if the key is missing. [] raises a KeyError.', 3),
  ('dev-q24', 'person.keys() returns:', '["A list of values","A dict_keys view of all keys","A list of key-value tuples","The number of keys"]', 1, '.keys() returns a view object of all keys. Use list(person.keys()) to get a plain list.', 4),
  ('dev-q24', 'person.values() returns:', '["All keys","A dict_values view of all values","A sorted list","The first value"]', 1, '.values() returns a view of all values in the dictionary.', 5),
  ('dev-q24', 'person.items() returns:', '["Only keys","Only values","A view of (key, value) tuple pairs","A dict copy"]', 2, '.items() returns (key, value) pairs — great for iterating: for k, v in person.items():', 6),
  ('dev-q24', 'How do you add or update a key in a dict?', '["person.add(\"score\", 100)","person[\"score\"] = 100","person.set(\"score\", 100)","person.update.score(100)"]', 1, 'Simply assign: person["score"] = 100. This adds if new, or updates if it exists.', 7),
  ('dev-q24', 'person.pop("age") does:', '["Returns age without removing","Removes \"age\" and returns its value","Returns None","Raises KeyError always"]', 1, '.pop(key) removes the key and returns its value. Raises KeyError if key does not exist.', 8),
  ('dev-q24', 'A dict comprehension to square numbers: {x: x**2 for x in range(3)} gives:', '["[0,1,4]","{0:0, 1:1, 2:4}","(0,1,4)","Error"]', 1, 'Dict comprehensions create dicts: {key: value for item in iterable}. Result: {0:0, 1:1, 2:4}.', 9),
  ('dev-q24', 'To check if "name" is a key in person dict:', '["person.hasKey(\"name\")","\"name\" in person","person.contains(\"name\")","person[\"name\"] exists"]', 1, 'The in operator checks for key existence: "name" in person returns True or False.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q25: Python Functions Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q25', 'The correct syntax to define a function in Python:', '["function greet(): ","def greet():","fn greet():","define greet():"]', 1, 'Python uses the def keyword: def function_name(parameters):. The body is indented.', 1),
  ('dev-q25', 'A docstring is:', '["A comment with #","A string on the first line of a function describing what it does","A function name","A return statement"]', 1, 'Docstrings use triple quotes """...""" right after def. They document what the function does.', 2),
  ('dev-q25', 'def add(a, b): return a + b. What does add(3, 4) return?', '["3","4","7","None"]', 2, 'The function returns a + b. add(3, 4) returns 7.', 3),
  ('dev-q25', 'A function without a return statement returns:', '["0","False","None","Error"]', 2, 'Functions without an explicit return statement implicitly return None.', 4),
  ('dev-q25', 'def greet(name="World"). If called as greet(), name is:', '["None","\"name\"","\"World\"","Error"]', 2, 'Default parameters provide a fallback value when no argument is given.', 5),
  ('dev-q25', 'def func(*args) — *args collects:', '["Keyword arguments","All positional arguments into a tuple","The first argument","Optional arguments"]', 1, '*args collects any number of positional arguments into a tuple you can iterate over.', 6),
  ('dev-q25', 'def func(**kwargs) — **kwargs collects:', '["All positional args","All keyword arguments into a dictionary","Two arguments","Default arguments"]', 1, '**kwargs collects any number of keyword arguments (name=value) into a dictionary.', 7),
  ('dev-q25', 'A lambda function: square = lambda x: x ** 2. square(5) returns:', '["lambda","x ** 2","25","Error"]', 2, 'Lambda creates a small anonymous function. lambda x: x**2 returns x squared. 5**2 = 25.', 8),
  ('dev-q25', 'def count(): count.n += 1; return count.n — this is an example of:', '["Recursion","Using a function attribute as persistent state","A lambda","A generator"]', 1, 'You can attach attributes to functions (count.n) to maintain state between calls.', 9),
  ('dev-q25', 'Returning multiple values: def minmax(lst): return min(lst), max(lst). This returns:', '["A list","Two separate values","A tuple","An error"]', 2, 'Python returns multiple values as a tuple. a, b = minmax([1,5,3]) unpacks them.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q26: Python Loops Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q26', 'for i in range(5) iterates with i as:', '["1,2,3,4,5","0,1,2,3,4","0,1,2,3,4,5","1,2,3,4"]', 1, 'range(5) generates 0, 1, 2, 3, 4 — five values starting from 0.', 1),
  ('dev-q26', 'range(2, 8) generates:', '["2,3,4,5,6,7,8","2,3,4,5,6,7","1,2,3,4,5,6,7,8","2,4,6,8"]', 1, 'range(start, stop) generates from start up to (but not including) stop: 2,3,4,5,6,7.', 2),
  ('dev-q26', 'range(0, 10, 2) generates:', '["0,2,4,6,8","0,2,4,6,8,10","1,3,5,7,9","2,4,6,8,10"]', 0, 'The third argument is the step. range(0, 10, 2) gives 0, 2, 4, 6, 8.', 3),
  ('dev-q26', 'break in a loop:', '["Skips one iteration","Exits the entire loop immediately","Pauses the loop","Continues to the next loop"]', 1, 'break immediately exits the innermost loop it is in.', 4),
  ('dev-q26', 'continue in a loop:', '["Exits the loop","Skips the rest of the current iteration and goes to the next","Pauses","Resets the counter"]', 1, 'continue skips the remaining code in the current iteration and moves to the next one.', 5),
  ('dev-q26', 'A for...else block: the else runs when:', '["The for loop finds a match","The for loop completes normally without hitting a break","Every iteration","An error occurs"]', 1, 'else on a for loop runs only if the loop was not interrupted by break.', 6),
  ('dev-q26', 'enumerate(["a","b","c"]) lets you:', '["Reverse the list","Loop with both index and value: (0,''a''), (1,''b''), (2,''c'')","Count items","Sort items"]', 1, 'enumerate() pairs each item with its index — great for when you need both in a for loop.', 7),
  ('dev-q26', 'zip([1,2,3], ["a","b","c"]) produces:', '["[[1,2,3],[\"a\",\"b\",\"c\"]]","[(1,\"a\"),(2,\"b\"),(3,\"c\")]","[1,2,3,\"a\",\"b\",\"c\"]","Error"]', 1, 'zip() pairs up items from two (or more) iterables into tuples.', 8),
  ('dev-q26', 'A list comprehension [x*2 for x in range(4)] returns:', '["[0,1,2,3]","[0,2,4,6]","[2,4,6,8]","[1,2,3,4]"]', 1, 'List comprehensions are concise loops that build lists. x*2 for x in 0,1,2,3 gives [0,2,4,6].', 9),
  ('dev-q26', 'A while loop requires careful attention to:', '["Indentation only","Updating the condition variable, otherwise you get an infinite loop","Using range()","Using enumerate()"]', 1, 'If you forget to update the variable the while condition checks, the loop runs forever.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q27: Python Strings Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q27', 'Strings in Python are immutable, which means:', '["You cannot create new strings","You cannot change the characters of an existing string","Strings cannot be printed","Strings cannot contain numbers"]', 1, 'Immutable means once created, a string object cannot be modified. s[0] = "X" raises a TypeError.', 1),
  ('dev-q27', 'An f-string: name = "Sam"; f"Hello, {name}!" outputs:', '["Hello, {name}!","Hello, Sam!","f\"Hello, Sam!\"","Error"]', 1, 'f-strings (formatted string literals) embed variables directly with {}. Result: "Hello, Sam!"', 2),
  ('dev-q27', '"Hello {}".format("World") returns:', '["Hello {}","Hello World","Hello {World}","Error"]', 1, '.format() replaces {} placeholders with the provided arguments.', 3),
  ('dev-q27', '"hello world".split(" ") returns:', '["\"hello world\"","[\"hello\", \"world\"]","[\"hello world\"]","Error"]', 1, 'split(separator) divides the string at each occurrence of the separator.', 4),
  ('dev-q27', '" ".join(["hello", "world"]) returns:', '["[\"hello\", \"world\"]","helloworld","hello world","Error"]', 2, 'join() concatenates list items with the separator string between them: "hello world".', 5),
  ('dev-q27', '"  hello  ".strip() returns:', '["\"  hello  \"","\"hello\"","\"hello  \"","\"  hello\""]', 1, 'strip() removes leading AND trailing whitespace. lstrip() and rstrip() do one side each.', 6),
  ('dev-q27', '"hello world".replace("world", "Python") returns:', '["\"hello world\"","\"hello Python\"","\"Python world\"","Error"]', 1, 'replace(old, new) returns a new string with all occurrences of old replaced by new.', 7),
  ('dev-q27', '"hello"[1:4] returns:', '["\"hel\"","\"ell\"","\"llo\"","\"hello\""]', 1, 'String slicing works like list slicing: index 1 to 3 (not including 4) gives "ell".', 8),
  ('dev-q27', 'A raw string r"C:\new\file" treats the backslashes as:', '["Escape sequences","Literal backslash characters","Invalid syntax","Unicode escapes"]', 1, 'Raw strings (r"...") treat backslashes as literal characters, useful for file paths and regex.', 9),
  ('dev-q27', '"ha" * 3 in Python returns:', '["\"ha ha ha\"","\"hahaha\"","3","Error"]', 1, 'String multiplication repeats the string: "ha" * 3 gives "hahaha".', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q28: Python File I/O Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q28', 'open("data.txt", "r") opens the file in:', '["Read mode","Write mode","Append mode","Binary mode"]', 0, '"r" is read mode — the default. The file must already exist or you get a FileNotFoundError.', 1),
  ('dev-q28', 'open("data.txt", "w") opens the file in:', '["Read mode","Write mode (creates file or OVERWRITES existing content)","Append mode","Execute mode"]', 1, '"w" write mode creates the file if it doesn''t exist, or clears it if it does!', 2),
  ('dev-q28', 'open("data.txt", "a") opens the file in:', '["Read mode","Overwrite mode","Append mode (adds to the end without erasing)","Archive mode"]', 2, '"a" append mode adds new content at the end of the file without erasing existing content.', 3),
  ('dev-q28', 'The with statement for files:', '["Is optional","Automatically closes the file when done, even if an error occurs","Is only for reading","Speeds up file access"]', 1, '"with open(...) as f:" guarantees the file is closed cleanly — best practice always.', 4),
  ('dev-q28', 'f.read() returns:', '["The first line","Each line as a list","The entire file content as one string","A file object"]', 2, 'read() reads the entire file and returns it as a single string.', 5),
  ('dev-q28', 'f.readline() returns:', '["The entire file","The next single line including the newline character","All lines as a list","The last line"]', 1, 'readline() reads one line at a time, including the \\n at the end.', 6),
  ('dev-q28', 'f.readlines() returns:', '["One string","A list of strings, one per line","Nothing","The file size"]', 1, 'readlines() returns a list where each element is a line from the file (including \\n).', 7),
  ('dev-q28', 'f.write("hello") does:', '["Prints hello","Writes the string to the file and returns the number of characters written","Appends always","Reads then writes"]', 1, 'write() writes the string to the file. It does NOT add a newline — you must add \\n yourself.', 8),
  ('dev-q28', 'If you try to open a non-existent file with "r" mode:', '["Creates a new empty file","Returns None","Raises FileNotFoundError","Returns empty string"]', 1, 'Read mode requires the file to exist. Missing files raise FileNotFoundError.', 9),
  ('dev-q28', 'To read a CSV file with Python''s csv module, you use:', '["open() only","csv.reader() inside a with block","pandas only","csv.load()"]', 1, 'import csv, then use csv.reader(f) to iterate over rows as lists of strings.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q29: Python Classes Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q29', 'How do you define a class in Python?', '["def MyClass:","class MyClass:","object MyClass:","type MyClass:"]', 1, 'Classes use the class keyword: class ClassName: followed by an indented body.', 1),
  ('dev-q29', '__init__ is called:', '["When the class is defined","When a new instance (object) of the class is created","When the class is deleted","When a method is called"]', 1, '__init__ is the constructor method — it runs automatically when you create a new object.', 2),
  ('dev-q29', 'The first parameter of every instance method is:', '["this","cls","self","obj"]', 2, 'By convention (and requirement), the first parameter is self — a reference to the instance.', 3),
  ('dev-q29', 'Instance attributes are:', '["Shared by all objects of the class","Unique to each specific object (set via self.attr = value)","Set outside the class","Read-only"]', 1, 'Instance attributes (self.name) are individual to each object. Class attributes are shared.', 4),
  ('dev-q29', 'Class attributes are defined:', '["Inside __init__ with self.","Inside methods only","Directly in the class body, outside methods — shared by all instances","Outside the class"]', 2, 'Class attributes sit directly in the class body. All instances share the same value.', 5),
  ('dev-q29', 'Inheritance: class Dog(Animal) means:', '["Dog replaces Animal","Dog inherits all attributes and methods from Animal","Dog and Animal are the same","Animal inherits from Dog"]', 1, 'Inheritance lets Dog reuse code from Animal. Dog can add or override Animal''s methods.', 6),
  ('dev-q29', 'super().__init__() inside a child class:', '["Replaces the parent class","Calls the parent class''s __init__ so its setup code still runs","Deletes the parent","Creates a new class"]', 1, 'super() calls the parent class. super().__init__() ensures the parent is properly initialized.', 7),
  ('dev-q29', '__str__ method is used to:', '["Delete the object","Define what str(obj) or print(obj) displays for the object","Initialize the object","Compare objects"]', 1, '__str__ returns a human-readable string representation: print(dog) calls dog.__str__().', 8),
  ('dev-q29', 'The @property decorator lets you:', '["Make a method into a class attribute","Access a method like an attribute without calling it with ()","Create static methods","Delete attributes"]', 1, '@property turns a method into a readable attribute: obj.area instead of obj.area().', 9),
  ('dev-q29', 'Encapsulation in Python classes means:', '["Classes cannot be changed","Bundling data and methods together, with _name convention for private attributes","All attributes are public","Classes cannot be inherited"]', 1, 'Encapsulation bundles data with behaviour. _name (single underscore) signals "private by convention".', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q30: Python Libraries Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q30', 'import math — to use the square root function you write:', '["math(sqrt(16))","math.sqrt(16)","sqrt(16)","from math import sqrt(16)"]', 1, 'After import math, access functions with dot notation: math.sqrt(16) returns 4.0.', 1),
  ('dev-q30', 'from random import randint — randint(1, 6) returns:', '["A float between 1 and 6","A random integer between 1 and 6 inclusive","Always 1","A list"]', 1, 'randint(a, b) returns a random integer from a to b, including both endpoints.', 2),
  ('dev-q30', 'The os module is used for:', '["Drawing graphics","Interacting with the operating system: files, directories, environment variables","Internet requests","Maths"]', 1, 'os provides tools for working with the operating system: os.path, os.listdir(), os.getcwd(), etc.', 3),
  ('dev-q30', 'The sys module provides access to:', '["Databases","Python interpreter info: sys.argv (command-line args), sys.exit(), sys.path","Internet","Random numbers"]', 1, 'sys lets you interact with the Python runtime itself: exit, command-line args, Python version.', 4),
  ('dev-q30', 'pip is:', '["A Python data type","Python''s package installer used to install third-party libraries","A built-in module","A code editor"]', 1, 'pip install package_name downloads and installs packages from PyPI (the Python Package Index).', 5),
  ('dev-q30', 'The datetime module lets you:', '["Connect to databases","Work with dates and times: datetime.now(), timedelta, date formatting","Sort lists","Read files"]', 1, 'datetime.datetime.now() gives the current date and time. You can also format, parse, and compare dates.', 6),
  ('dev-q30', 'import random; random.choice(["rock","paper","scissors"]) returns:', '["All three items","A random item from the list","The first item","None"]', 1, 'random.choice() picks one random element from a sequence.', 7),
  ('dev-q30', 'The requests library (third-party) is used for:', '["Sorting data","Making HTTP requests to web APIs and websites","Working with files","Maths"]', 1, 'requests.get(url) fetches web pages or API data. Install with: pip install requests.', 8),
  ('dev-q30', 'The pandas library is used for:', '["Web scraping only","Data analysis — loading, cleaning, and analysing tabular data with DataFrames","Game development","Creating GUIs"]', 1, 'pandas is the go-to data science library. pd.read_csv() loads spreadsheet-like data into DataFrames.', 9),
  ('dev-q30', 'from math import pi — what does this do?', '["Imports the entire math module","Imports only the pi constant directly into the namespace so you can use pi instead of math.pi","Creates a variable pi = 3.14","Imports all of math"]', 1, '"from module import name" lets you use name directly without the module prefix.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;
