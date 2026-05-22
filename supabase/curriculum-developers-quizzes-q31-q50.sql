-- =============================================================================
-- CODEship Academy — Developers Quizzes Q31–Q50 (Full Questions)
-- Target: Ages 11–14 | CS Theory, Web Dev, Tools, Security, Databases, Frameworks
-- 20 quizzes × 10 questions = 200 questions total
-- =============================================================================

-- Q31: Algorithms Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q31', 'What is an algorithm?', '["A programming language","A step-by-step set of instructions for solving a problem","A type of computer hardware","A website layout"]', 1, 'An algorithm is a precise, ordered set of steps that solves a problem or accomplishes a task.', 1),
  ('dev-q31', 'Which of these is an example of a sequential step in an algorithm?', '["If the number is even, print it","Repeat until the list is empty","Add 5 to the total","While balance > 0, subtract payment"]', 2, 'Sequential steps run one after another in order. "Add 5 to the total" is a single sequential action.', 2),
  ('dev-q31', 'Pseudocode is:', '["Real code that runs on a computer","A way to plan an algorithm using plain English-like steps before writing real code","A type of binary code","A Python library"]', 1, 'Pseudocode uses informal language to describe algorithm steps — it helps you plan before coding.', 3),
  ('dev-q31', 'A flowchart uses a diamond shape to represent:', '["A start or end point","A process step","A decision (yes/no question)","Input or output"]', 2, 'Diamond shapes in flowcharts represent decisions — they have two paths: yes or no.', 4),
  ('dev-q31', 'What does it mean for an algorithm to be correct?', '["It runs as fast as possible","It produces the right output for every valid input","It uses the least memory","It is written in Python"]', 1, 'Correctness means the algorithm always gives the right answer — speed is a separate concern called efficiency.', 5),
  ('dev-q31', 'Linear search works by:', '["Jumping to the middle element first","Checking every element one by one from the start","Sorting the list first","Dividing the list in half repeatedly"]', 1, 'Linear search checks each item in order until it finds the target or reaches the end.', 6),
  ('dev-q31', 'Binary search requires that the list is:', '["Unsorted","Sorted","All even numbers","Stored in a dictionary"]', 1, 'Binary search only works on sorted lists — it repeatedly halves the search space.', 7),
  ('dev-q31', 'Binary search on 1000 items needs at most how many comparisons?', '["1000","500","About 10","Exactly 100"]', 2, 'Binary search needs at most log₂(n) steps. log₂(1000) ≈ 10, making it far faster than linear search.', 8),
  ('dev-q31', 'An iterative step in an algorithm is one that:', '["Makes a decision","Repeats a set of steps (a loop)","Runs once in sequence","Returns a value"]', 1, 'Iterative steps use loops (repeat, while, for) to run the same instructions multiple times.', 9),
  ('dev-q31', 'Algorithm A takes 10 steps for 10 items and 100 steps for 100 items. Algorithm B takes 10 steps for 10 items and 20 steps for 100 items. Which is more efficient?', '["Algorithm A","Algorithm B","They are equal","It depends on the computer"]', 1, 'Algorithm B scales much better — it only doubles steps when items multiply by 10. Algorithm A grows linearly.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q32: Sorting Algorithms Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q32', 'Bubble sort works by:', '["Selecting the smallest element and placing it at the front","Repeatedly swapping adjacent elements that are in the wrong order","Dividing the list in half and sorting each half","Inserting each element into its correct position"]', 1, 'Bubble sort compares and swaps adjacent pairs repeatedly until the list is sorted.', 1),
  ('dev-q32', 'Selection sort works by:', '["Swapping adjacent elements","Finding the smallest unsorted element and placing it at the start of the unsorted part","Merging sorted halves","Inserting each element one by one"]', 1, 'Selection sort finds the minimum in the remaining unsorted portion and swaps it into position.', 2),
  ('dev-q32', 'Insertion sort works by:', '["Swapping all adjacent pairs","Selecting minimums","Taking each element and inserting it into the correct position in the already-sorted part","Splitting the list"]', 2, 'Insertion sort builds a sorted section one element at a time, inserting each new element where it belongs.', 3),
  ('dev-q32', 'What is the time complexity of bubble, selection, and insertion sort in the worst case?', '["O(n)","O(n log n)","O(n²)","O(log n)"]', 2, 'All three basic sorts have O(n²) worst-case — they need roughly n×n comparisons for n items.', 4),
  ('dev-q32', 'A "stable" sorting algorithm:', '["Always runs in O(n log n)","Preserves the original order of equal elements","Uses no extra memory","Works only on numbers"]', 1, 'Stable sorts keep equal elements in their original relative order — important when sorting objects by one field.', 5),
  ('dev-q32', 'What is the best case for insertion sort?', '["O(n²) — always the same","O(n) — the list is already sorted","O(log n)","O(n log n)"]', 1, 'If the list is already sorted, insertion sort only makes one comparison per element — just O(n).', 6),
  ('dev-q32', 'Merge sort works by:', '["Swapping adjacent elements","Selecting minimums repeatedly","Dividing the list in half, sorting each half, then merging them back","Picking a pivot and partitioning"]', 2, 'Merge sort is a divide-and-conquer algorithm: split, sort each half recursively, then merge.', 7),
  ('dev-q32', 'Quick sort works by:', '["Inserting elements one by one","Choosing a pivot, placing smaller items before it and larger items after it, then recursing","Merging sorted sublists","Selecting the minimum each time"]', 1, 'Quick sort picks a pivot, partitions the list around it, then recursively sorts each partition.', 8),
  ('dev-q32', 'Python''s built-in sorted() function uses which algorithm?', '["Bubble sort","Quick sort","Timsort (a hybrid of merge sort and insertion sort)","Selection sort"]', 2, 'Python uses Timsort, a hybrid algorithm designed for real-world data — it is fast and stable.', 9),
  ('dev-q32', 'When should you use a built-in sort instead of writing your own?', '["Never — custom sorts are always better","Always — built-ins are well-tested, fast, and reliable for most cases","Only for numbers","Only for strings"]', 1, 'Built-in sorts are optimised, tested, and correct. Only write custom sorts when you have a very specific need.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q33: Data Structures Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q33', 'A stack follows which principle?', '["FIFO — First In, First Out","LIFO — Last In, First Out","Random access","Sorted order"]', 1, 'Stacks are LIFO: the last item pushed on is the first one popped off — like a stack of plates.', 1),
  ('dev-q33', 'A queue follows which principle?', '["LIFO — Last In, First Out","FIFO — First In, First Out","Random access","Sorted order"]', 1, 'Queues are FIFO: the first item added is the first item removed — like a line at a shop.', 2),
  ('dev-q33', 'What is the main advantage of a linked list over an array?', '["Faster random access","Easier to insert and delete items without shifting all other elements","Less memory usage","Built-in sorting"]', 1, 'Linked lists allow O(1) insertions/deletions anywhere without shifting elements; arrays require shifting.', 3),
  ('dev-q33', 'A hash table stores data using:', '["Sorted indexes","A key run through a hash function to find a storage location","A binary tree structure","A linked list of queues"]', 1, 'Hash tables compute an index from the key using a hash function, allowing very fast lookups.', 4),
  ('dev-q33', 'In computer science, a tree is:', '["A sorted list","A data structure with a root node, where each node has child nodes","A type of hash table","A linear structure like an array"]', 1, 'Trees are hierarchical — one root node, with branches leading to child nodes, like a family tree.', 5),
  ('dev-q33', 'A binary tree is a tree where:', '["Every node has exactly two children","Each node has at most two children","Nodes are stored in pairs","Only two nodes exist"]', 1, 'In a binary tree, each node has at most a left child and a right child (0, 1, or 2 children).', 6),
  ('dev-q33', 'You are building a browser history (back button). Which structure fits best?', '["Queue","Binary tree","Stack","Hash table"]', 2, 'Browser history is a stack — the last page visited is the first one you go back to (LIFO).', 7),
  ('dev-q33', 'In Python, a list used as a stack would use which methods?', '["append() and pop()","push() and shift()","enqueue() and dequeue()","add() and remove()"]', 0, 'Python lists use append() to push onto the stack and pop() to pop off the end (LIFO).', 8),
  ('dev-q33', 'Python''s collections.deque is preferred for a queue because:', '["It is sorted","It allows O(1) appends and pops from both ends, unlike list which is slow at the front","It is a dictionary","It uses less memory than a list"]', 1, 'deque has O(1) popleft() while list.pop(0) is O(n) — deque is the right tool for FIFO queues.', 9),
  ('dev-q33', 'A Python dictionary is an example of which data structure?', '["Stack","Queue","Hash table / hash map","Binary tree"]', 2, 'Python dicts use hashing internally — key lookups are O(1) on average, just like a hash table.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q34: Binary and Number Systems Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q34', 'Binary is called "base 2" because:', '["It uses 2 bytes per digit","It only uses two digits: 0 and 1","It was invented by 2 people","Numbers are stored in pairs"]', 1, 'Base 2 means only two possible digit values: 0 and 1. Each position represents a power of 2.', 1),
  ('dev-q34', 'What is a "bit"?', '["8 binary digits","A single binary digit (0 or 1)","A unit of file size equal to 1000 bytes","A type of processor"]', 1, 'A bit (binary digit) is the smallest unit of data — it is either 0 or 1.', 2),
  ('dev-q34', 'How many bits make one byte?', '["4","8","16","2"]', 1, 'One byte = 8 bits. This is a fundamental unit — a byte can represent 256 different values (0–255).', 3),
  ('dev-q34', 'What is the decimal value of binary 1010?', '["4","8","10","12"]', 2, '1010 in binary = 1×8 + 0×4 + 1×2 + 0×1 = 8 + 2 = 10.', 4),
  ('dev-q34', 'To convert decimal 13 to binary, you repeatedly:', '["Multiply by 2","Divide by 2 and record remainders","Add powers of 2","Subtract 8 then 4 then 2 then 1"]', 1, 'Divide by 2, note the remainder (0 or 1), repeat. Reading remainders bottom-to-top gives the binary number.', 5),
  ('dev-q34', 'Hexadecimal uses base 16, meaning it has digits:', '["0–9 only","0–9 and A–F (where A=10, B=11 ... F=15)","0–F only","1–16"]', 1, 'Hex uses 0–9 then A–F to represent values 10–15 with a single character, making binary more readable.', 6),
  ('dev-q34', 'Why do computers use binary (0s and 1s)?', '["Binary maths is easier","Electronic circuits naturally represent two states: on (1) and off (0)","Binary uses less memory","Programmers preferred it"]', 1, 'Transistors in CPUs switch between two electrical states (on/off), which map perfectly to 1 and 0.', 7),
  ('dev-q34', 'ASCII is:', '["A type of processor","A standard that maps numbers to characters (e.g., 65 = ''A'')","A binary sorting method","A type of binary file"]', 1, 'ASCII assigns a number to each character: uppercase A is 65, B is 66, space is 32, etc.', 8),
  ('dev-q34', 'In Python, 0b1010 is:', '["A string","A syntax error","The integer 10 written in binary literal notation","The float 1.010"]', 2, 'The 0b prefix tells Python the number is in binary. 0b1010 equals decimal 10.', 9),
  ('dev-q34', 'What does Python''s bin(10) return?', '["10","1010","''0b1010''","''binary 10''"]', 2, 'bin() returns a string of the binary representation with a ''0b'' prefix. bin(10) returns ''0b1010''.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q35: Web APIs Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q35', 'What does API stand for?', '["Application Programming Interface","Automated Page Integration","App Protocol Index","Advanced Programming Instructions"]', 0, 'API = Application Programming Interface — a way for different software systems to talk to each other.', 1),
  ('dev-q35', 'A REST API uses which protocol to send and receive data?', '["FTP","SMTP","HTTP/HTTPS","SSH"]', 2, 'REST APIs communicate over HTTP/HTTPS — the same protocol used by web browsers.', 2),
  ('dev-q35', 'Which HTTP method is used to READ data from a REST API?', '["POST","PUT","DELETE","GET"]', 3, 'GET requests retrieve data without changing anything on the server.', 3),
  ('dev-q35', 'Which HTTP method is used to CREATE new data on a server?', '["GET","PUT","POST","DELETE"]', 2, 'POST sends data to create a new resource on the server.', 4),
  ('dev-q35', 'HTTP status code 200 means:', '["Not Found","Server Error","OK — the request was successful","Unauthorised"]', 2, '200 OK means the request succeeded. Status codes in the 200s generally mean success.', 5),
  ('dev-q35', 'HTTP status code 404 means:', '["OK","Server Error","Redirect","Not Found — the resource does not exist"]', 3, '404 Not Found means the requested URL/resource does not exist on the server.', 6),
  ('dev-q35', 'JSON is used in APIs because:', '["It is the fastest format","It is a lightweight, human-readable text format that most languages can parse","It is required by HTTP","It is more secure than XML"]', 1, 'JSON (JavaScript Object Notation) is easy to read and write, and every major language has JSON support.', 7),
  ('dev-q35', 'An API key is:', '["A password for the database","A unique identifier that authenticates your app to use an API","A type of JSON field","The URL of the API"]', 1, 'API keys identify and authenticate the caller — they let the API track and limit usage per app.', 8),
  ('dev-q35', 'Rate limiting in an API means:', '["The API only accepts JSON","Requests are limited in number per time period to prevent abuse","The API only works on fast connections","Responses are delayed by a rate"]', 1, 'Rate limiting caps how many requests you can make (e.g., 100 per minute) to keep the server stable.', 9),
  ('dev-q35', 'In JavaScript, after fetch(url), you call response.json() to:', '["Send JSON to the server","Check if the response is OK","Parse the response body as JSON into a JavaScript object","Convert a JS object to JSON"]', 2, 'response.json() reads the response body and parses it as JSON, returning a promise with the JS object.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q36: CSS Animations Advanced Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q36', 'Which CSS rule defines the keyframes of an animation?', '["@animation","@keyframes","@frames","@transition"]', 1, '@keyframes defines the intermediate steps of a CSS animation — what changes at each point.', 1),
  ('dev-q36', 'Which property links an element to a @keyframes rule?', '["animation-keyframes","animation-name","animation-style","keyframe-name"]', 1, 'animation-name: slidein; links the element to the @keyframes slidein { } rule.', 2),
  ('dev-q36', 'animation-timing-function: ease-in-out means:', '["The animation plays at constant speed","The animation starts slow, speeds up in the middle, then slows at the end","The animation starts fast and ends fast","The animation eases into the next loop"]', 1, 'ease-in-out creates a natural-feeling motion: slow start, fast middle, slow end.', 3),
  ('dev-q36', 'animation-fill-mode: forwards means:', '["The animation plays forward, not backward","After the animation ends, the element keeps the styles from the last keyframe","The animation loops forward","The element disappears after animation"]', 1, 'forwards keeps the final animation state applied after the animation finishes, preventing a snap back.', 4),
  ('dev-q36', 'transform: translate(50px, 0) does:', '["Rotates the element 50 degrees","Scales the element by 50%","Moves the element 50px to the right","Skews the element"]', 2, 'translate(x, y) moves an element along the X and Y axes. 50px, 0 moves it 50px to the right.', 5),
  ('dev-q36', 'What is the difference between a CSS transition and a CSS animation?', '["There is no difference","Transitions animate between two states when a property changes; animations use @keyframes for more complex, multi-step sequences","Animations only work on hover","Transitions can loop, animations cannot"]', 1, 'Transitions are simple A-to-B changes triggered by state (like hover). Animations use @keyframes for full control.', 6),
  ('dev-q36', 'animation-iteration-count: infinite means:', '["The animation runs once","The animation runs 0 times","The animation repeats forever","The animation runs infinitely fast"]', 2, 'Setting iteration-count to infinite makes the animation loop endlessly — useful for loaders and spinners.', 7),
  ('dev-q36', 'animation-play-state: paused does:', '["Deletes the animation","Stops/pauses the animation at its current position","Resets to the first keyframe","Speeds up the animation"]', 1, 'paused freezes the animation at its current frame. Toggle it to running to resume from where it stopped.', 8),
  ('dev-q36', 'The will-change property is used to:', '["Change the animation name","Hint to the browser that an element will animate, allowing it to optimise rendering ahead of time","Set the animation delay","Define which properties will change in @keyframes"]', 1, 'will-change: transform tells the browser to prepare a compositing layer, improving animation performance.', 9),
  ('dev-q36', 'When should you prefer CSS animations over JavaScript animations?', '["Never — JS is always better","For simple, declarative, performance-critical animations (the browser can run them on the GPU)","Only for colour changes","Only on mobile devices"]', 1, 'CSS animations run on the browser''s compositor thread (GPU), making them smoother than JS-driven style changes.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q37: Git and Version Control Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q37', 'What does git init do?', '["Downloads a repository from GitHub","Creates a new local Git repository in the current folder","Adds all files to staging","Pushes code to a remote server"]', 1, 'git init initialises a brand-new Git repository — it creates a hidden .git folder to track history.', 1),
  ('dev-q37', 'What does git add do?', '["Saves a snapshot of changes permanently","Uploads to GitHub","Stages changes, marking them to be included in the next commit","Creates a new branch"]', 2, 'git add moves changes to the staging area — a preparation zone before you commit.', 2),
  ('dev-q37', 'What does git commit -m "message" do?', '["Stages all changes","Saves a permanent snapshot of staged changes with a message","Sends code to GitHub","Creates a new branch"]', 1, 'git commit saves the staged snapshot permanently in the repository history with a descriptive message.', 3),
  ('dev-q37', 'What does git status show?', '["The commit history","Which files are staged, unstaged, or untracked","The current branch only","Remote repository info"]', 1, 'git status shows the current state of your working directory and staging area.', 4),
  ('dev-q37', 'What does git log show?', '["All branches","The commit history — author, date, message, and hash for each commit","File changes in the working directory","Remote repositories"]', 1, 'git log displays the list of commits in the current branch''s history.', 5),
  ('dev-q37', 'A branch in Git is:', '["A copy of the entire repository on a new computer","An independent line of development — a pointer to a specific commit","A backup of deleted files","A type of commit message"]', 1, 'Branches let you work on features without affecting the main code. They are cheap, lightweight pointers.', 6),
  ('dev-q37', 'git checkout -b feature creates:', '["A new commit","A new branch named feature and switches to it","A new remote repository","A merge"]', 1, '-b creates the branch and switches to it in one command. Same as git branch + git checkout.', 7),
  ('dev-q37', 'git merge feature does:', '["Deletes the feature branch","Downloads changes from GitHub","Integrates the commits from the feature branch into the current branch","Creates a pull request"]', 2, 'git merge combines the history of the specified branch into your current branch.', 8),
  ('dev-q37', 'What is the difference between git pull and git fetch?', '["No difference","git fetch downloads changes from remote without merging; git pull downloads AND merges them","git pull only downloads, git fetch also merges","git fetch deletes remote branches"]', 1, 'fetch is safe — it just downloads. pull = fetch + merge, updating your local branch.', 9),
  ('dev-q37', 'GitHub is:', '["The same as Git","A web-based platform for hosting Git repositories and collaborating on code","A programming language","A code editor"]', 1, 'Git is the version control tool; GitHub is a cloud service built on top of Git for collaboration and storage.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q38: Command Line Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q38', 'The terminal (command line) is:', '["A graphical file explorer","A text-based interface for talking directly to your computer by typing commands","A code editor","A web browser"]', 1, 'The terminal lets you control your computer by typing commands — it is powerful and used by all developers.', 1),
  ('dev-q38', 'What does the ls command do on macOS/Linux?', '["Deletes files","Lists files and folders in the current directory","Changes directory","Shows network info"]', 1, 'ls (list) shows the contents of the current directory — like looking inside a folder.', 2),
  ('dev-q38', 'What does cd Documents do?', '["Creates a folder called Documents","Deletes the Documents folder","Changes the current directory to Documents","Lists the contents of Documents"]', 2, 'cd (change directory) moves you into the specified folder.', 3),
  ('dev-q38', 'What does mkdir projects do?', '["Deletes the projects folder","Lists projects","Creates a new directory called projects","Moves into the projects folder"]', 2, 'mkdir (make directory) creates a new folder with the given name.', 4),
  ('dev-q38', 'What does pwd stand for and do?', '["Print Working Data — shows file sizes","Print Working Directory — shows your current location in the file system","Previous Working Directory — goes back","Power Down — shuts down"]', 1, 'pwd prints the full path of the current directory, so you always know where you are.', 5),
  ('dev-q38', 'In a file path, .. means:', '["The current directory","The root directory","The parent directory (one level up)","A hidden file"]', 2, 'cd .. moves one level up in the directory tree, to the parent folder.', 6),
  ('dev-q38', 'What does cat README.md do?', '["Deletes README.md","Creates README.md","Displays the contents of README.md in the terminal","Copies README.md"]', 2, 'cat (concatenate) prints the file contents directly in the terminal — great for quick file reading.', 7),
  ('dev-q38', 'What does rm myfile.txt do?', '["Renames myfile.txt","Moves myfile.txt to trash","Permanently deletes myfile.txt (no recycle bin!)","Copies myfile.txt"]', 2, 'rm (remove) permanently deletes the file — there is no undo or recycle bin, so use with care!', 8),
  ('dev-q38', 'The > operator in a command like echo "hello" > file.txt:', '["Shows the output on screen","Appends output to the file","Redirects output, writing it to the file (overwrites existing content)","Pipes output to another command"]', 2, '> redirects stdout to a file, creating it if needed or overwriting it if it exists.', 9),
  ('dev-q38', 'The | (pipe) operator, e.g. ls | grep .js, does:', '["Runs two commands separately","Sends the output of the first command as input to the second command","Deletes matching files","Creates a new command"]', 1, 'The pipe | connects commands — the left command''s output becomes the right command''s input.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q39: Debugging Techniques Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q39', 'What is a bug in programming?', '["A feature request","An error or flaw in the code that causes it to behave incorrectly","A comment in the code","A type of loop"]', 1, 'A bug is any error that causes unexpected or incorrect behaviour — fixing bugs is called debugging.', 1),
  ('dev-q39', 'What is the simplest debugging technique in JavaScript?', '["Rewriting all the code","Using console.log() to print variable values and check what the code is doing","Deleting functions one by one","Commenting out the entire file"]', 1, 'console.log() lets you peek inside your code at runtime — it is the most-used debugging tool.', 2),
  ('dev-q39', 'Chrome DevTools breakpoints let you:', '["Delete lines of code","Pause code execution at a specific line and inspect all variable values at that moment","Change the HTML permanently","Speed up the page"]', 1, 'Breakpoints pause the running program, letting you step through code line by line and inspect state.', 3),
  ('dev-q39', 'A stack trace tells you:', '["How much memory the program is using","The sequence of function calls that led to the error, so you can find where things went wrong","The list of variables in scope","The browser version"]', 1, 'The stack trace shows the chain of function calls — reading it from top to bottom reveals the crash site.', 4),
  ('dev-q39', 'When reading an error message, the most important part to look at first is:', '["The line number and error type","The colour of the text","The time it happened","The file size"]', 0, 'The error type (e.g., TypeError) and line number pinpoint what went wrong and exactly where.', 5),
  ('dev-q39', 'A TypeError most commonly occurs when:', '["A file is missing","You try to use a value as a type it is not — like calling a non-function or accessing a property of undefined","The network is slow","A loop runs too many times"]', 1, 'TypeError: Cannot read properties of undefined is the classic example — you are using a value incorrectly.', 6),
  ('dev-q39', 'The difference between undefined and null is:', '["No difference","undefined means a variable was declared but never given a value; null is an intentional empty value","undefined is an error; null is zero","They are both errors"]', 1, 'undefined appears automatically (variable not set); null is deliberately assigned to represent emptiness.', 7),
  ('dev-q39', 'Rubber duck debugging means:', '["Asking a duck for help","Explaining your code step by step out loud (to anyone or anything) to find the logical flaw yourself","Using a special debugging tool","Printing the code on paper"]', 1, 'Explaining your problem aloud forces you to think through it carefully — often you spot the bug yourself!', 8),
  ('dev-q39', 'A linter (like ESLint) is a tool that:', '["Runs your tests","Automatically fixes all bugs","Analyses your code for style errors, suspicious patterns, and likely bugs before you run it","Formats your CSS"]', 2, 'Linters catch problems statically (without running the code): undefined variables, unused imports, etc.', 9),
  ('dev-q39', 'Test-Driven Development (TDD) means:', '["Writing tests after the code is done","Writing tests first (they fail), then writing code to make them pass","Never writing tests","Only testing edge cases"]', 1, 'TDD: Red (write failing test) → Green (write minimal code to pass) → Refactor. Tests drive the design.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q40: Web Security Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q40', 'XSS stands for:', '["Extra Style Sheets","Cross-Site Scripting — injecting malicious scripts into a web page viewed by others","Cross-Server Settings","External Style System"]', 1, 'XSS attacks inject malicious JavaScript into a page that other users then execute in their browsers.', 1),
  ('dev-q40', 'SQL injection is an attack where:', '["A database slows down","A user''s SQL client crashes","Malicious SQL code is inserted into an input field to manipulate or destroy a database","Too many queries are sent"]', 2, 'If user input is inserted directly into a SQL query, attackers can inject commands like DROP TABLE.', 2),
  ('dev-q40', 'HTTPS is important because:', '["It loads pages faster","It encrypts data between the browser and server, so attackers cannot read or modify it","It is required by all governments","It adds a padlock icon only"]', 1, 'HTTPS uses TLS encryption — without it, your passwords and data travel as plain text anyone can read.', 3),
  ('dev-q40', 'A password hash is:', '["The password stored in plain text","An encrypted version you can decrypt","A one-way transformation of the password — you cannot reverse it to get the original","The password encoded in Base64"]', 2, 'Hashing is one-way: you can check if a password matches the hash, but cannot get the original password back.', 4),
  ('dev-q40', 'Why must you never store passwords in plain text?', '["It wastes storage","If the database is breached, attackers immediately have everyone''s passwords","Plain text passwords are not allowed by HTTP","Users prefer hashed passwords"]', 1, 'Plain text leaks expose all users instantly. Hashes mean attackers must crack each one individually.', 5),
  ('dev-q40', 'CORS (Cross-Origin Resource Sharing) controls:', '["How CSS files are shared","Which web pages from other domains are allowed to make requests to your API","How images are cached","User authentication"]', 1, 'CORS headers tell the browser which origins are allowed to call your API, preventing unauthorised cross-site requests.', 6),
  ('dev-q40', 'The same-origin policy means:', '["All web pages look the same","JavaScript on one origin (domain/port) cannot read responses from a different origin by default","CSS from one site cannot style another","All browsers must look the same"]', 1, 'Same-origin policy is a browser security feature — it stops malicious sites from reading your bank''s data.', 7),
  ('dev-q40', 'A JWT (JSON Web Token) is:', '["A type of database","A file format for images","A compact, signed token used to securely transmit authentication information between parties","A JavaScript function"]', 2, 'JWTs contain claims (like user ID) and are signed so the server can verify they have not been tampered with.', 8),
  ('dev-q40', 'Input validation is important because:', '["It makes forms look nicer","It ensures data is in the expected format before processing, preventing malformed or malicious data from reaching your server","It speeds up the database","It is required by browsers"]', 1, 'Always validate on the server — never trust client-side validation alone as it can be bypassed.', 9),
  ('dev-q40', 'bcrypt is used to:', '["Encrypt files for download","Hash passwords with a built-in salt and work factor, making brute-force attacks very slow","Sign JWT tokens","Validate email addresses"]', 1, 'bcrypt deliberately runs slowly and adds a random salt — each attempt to crack takes significant time.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q41: Database Concepts Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q41', 'What is a database?', '["A type of programming language","An organised collection of structured data that can be stored, accessed, and managed","A CSS styling system","A web framework"]', 1, 'Databases store structured data in an organised way so it can be efficiently queried and updated.', 1),
  ('dev-q41', 'A database table is similar to a spreadsheet because:', '["Both use formulas","Both organise data into rows (records) and columns (fields)","Both are used for graphic design","Both store images"]', 1, 'Like a spreadsheet, a table has columns (the fields/types) and rows (each individual record).', 2),
  ('dev-q41', 'A primary key is:', '["The most important column in a table","A unique identifier for each row — no two rows can have the same primary key","The first column always","The column with the largest values"]', 1, 'Primary keys guarantee each row is unique and identifiable — often an auto-incrementing integer or UUID.', 3),
  ('dev-q41', 'What is a database query?', '["A type of table","A request to retrieve, insert, update, or delete data from the database","A connection to the internet","A backup of the database"]', 1, 'Queries are questions or instructions you send to the database — written in SQL for relational databases.', 4),
  ('dev-q41', 'A relational database differs from a NoSQL database because:', '["Relational databases are always faster","Relational databases store data in structured tables with defined relationships; NoSQL is more flexible with formats like JSON documents","NoSQL uses SQL too","Relational databases cannot store text"]', 1, 'Relational (SQL) databases enforce structure and relationships; NoSQL offers flexibility for unstructured data.', 5),
  ('dev-q41', 'SQL stands for:', '["Structured Query Language","Server Query Language","Simple Question Language","Standard Query List"]', 0, 'SQL = Structured Query Language — the standard language for working with relational databases.', 6),
  ('dev-q41', 'A foreign key is:', '["A key from another country","A column that references the primary key of another table, creating a link between them","An encrypted primary key","A key with special characters"]', 1, 'Foreign keys create relationships between tables — e.g., an orders table has a user_id that references the users table.', 7),
  ('dev-q41', 'A database index does:', '["Deletes duplicate rows","Numbers the rows from 1 onwards","Creates a data structure that speeds up lookups on a column, like an index at the back of a book","Locks the table"]', 2, 'Indexes trade storage space for speed — the database can find rows without scanning every one.', 8),
  ('dev-q41', 'CRUD stands for:', '["Create, Read, Update, Delete","Copy, Remove, Undo, Duplicate","Connect, Retrieve, Upload, Download","Compile, Run, Upload, Debug"]', 0, 'CRUD describes the four basic operations on data: Create (INSERT), Read (SELECT), Update (UPDATE), Delete (DELETE).', 9),
  ('dev-q41', 'When should you use a database instead of a flat file?', '["Always — files are never appropriate","When you need to search, filter, relate, or frequently update large amounts of structured data","When storing simple app configuration","When saving a single user''s settings"]', 1, 'Databases shine with complex queries, multiple users, relationships, and large data — files are fine for simple configs.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q42: SQL Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q42', 'What does SELECT * FROM users do?', '["Deletes all users","Creates a users table","Retrieves every column and row from the users table","Updates all users"]', 2, 'SELECT * means "select all columns". FROM users specifies the table. Together: return everything.', 1),
  ('dev-q42', 'The WHERE clause is used to:', '["Sort the results","Limit which rows are returned by applying a condition","Join two tables","Count rows"]', 1, 'WHERE filters rows: SELECT * FROM users WHERE age > 12 returns only users older than 12.', 2),
  ('dev-q42', 'ORDER BY name ASC sorts results:', '["From Z to A","Randomly","From A to Z alphabetically","By creation date"]', 2, 'ORDER BY sorts the result set. ASC = ascending (A→Z, 1→100). DESC = descending.', 3),
  ('dev-q42', 'LIMIT 5 in a query means:', '["Skip 5 rows","Return only the first 5 rows","Return rows 5 and above","Return every 5th row"]', 1, 'LIMIT restricts how many rows are returned — useful for pagination and performance.', 4),
  ('dev-q42', 'INSERT INTO users (name, age) VALUES (''Alex'', 12) does:', '["Updates a user named Alex","Deletes the user Alex","Adds a new row to the users table with name ''Alex'' and age 12","Creates the users table"]', 2, 'INSERT INTO adds a new row. You specify the column names and the corresponding values.', 5),
  ('dev-q42', 'UPDATE users SET age = 13 WHERE name = ''Alex'' does:', '["Deletes Alex","Creates a new user Alex","Changes the age column to 13 for rows where name is ''Alex''","Returns users named Alex"]', 2, 'UPDATE modifies existing rows. Always use WHERE — without it, every row in the table would be updated!', 6),
  ('dev-q42', 'DELETE FROM users WHERE id = 5 does:', '["Deletes the entire users table","Deletes only the row where id equals 5","Hides the row with id 5","Resets id 5 to default values"]', 1, 'DELETE removes specific rows. The WHERE clause is critical — DELETE without WHERE deletes everything!', 7),
  ('dev-q42', 'SELECT COUNT(*) FROM orders returns:', '["The first order","The total number of rows in the orders table","The sum of all order values","The largest order"]', 1, 'COUNT(*) is an aggregate function — it counts the total number of rows in the result.', 8),
  ('dev-q42', 'What does * mean in SELECT * FROM products?', '["Multiply all values","Select everything — return all columns","A wildcard for the table name","An alias"]', 1, '* is a wildcard meaning all columns. SELECT name, price would return only those two columns.', 9),
  ('dev-q42', 'A JOIN in SQL is used to:', '["Merge two databases","Combine rows from two tables based on a related column","Delete duplicates","Sort by multiple columns"]', 1, 'JOIN combines rows from two tables where a condition is met — usually a foreign key relationship.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q43: APIs and REST Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q43', 'REST stands for:', '["Remote Execution of Server Tasks","Representational State Transfer","Relational Entity Service Template","Rapid Endpoint Server Technology"]', 1, 'REST = Representational State Transfer — an architectural style for designing networked APIs.', 1),
  ('dev-q43', 'A REST API is "stateless" which means:', '["It does not return any data","Each request must contain all the information needed — the server stores no session between requests","It never changes data","It only returns static files"]', 1, 'Stateless means the server treats every request independently — no memory of previous requests.', 2),
  ('dev-q43', 'In REST, a "resource" is:', '["A computer","Any noun the API works with — e.g., a user, a post, a product","A type of HTTP method","A server error"]', 1, 'Resources are the things your API represents. URLs identify resources: /users/5 identifies user 5.', 3),
  ('dev-q43', 'In the CRUD-to-HTTP mapping, creating a new resource uses:', '["GET","PUT","DELETE","POST"]', 3, 'POST creates new resources. GET reads, PUT updates/replaces, DELETE removes. CRUD = POST/GET/PUT/DELETE.', 4),
  ('dev-q43', 'In the URL /products/42, the 42 is a:', '["Query parameter","HTTP header","URL path parameter — identifies a specific product resource","Response body"]', 2, 'Path parameters identify a specific resource. /products/42 means "the product with id 42".', 5),
  ('dev-q43', 'In the URL /search?q=python, the q=python part is a:', '["Path parameter","HTTP body","Fragment","Query parameter — passed in the URL after ?"]', 3, 'Query parameters come after ? and are used for filtering, searching, or optional inputs.', 6),
  ('dev-q43', 'HTTP status 201 Created means:', '["The request failed","The resource already exists","A new resource was successfully created","The server is busy"]', 2, '201 Created is returned after a successful POST — it confirms a new resource was made.', 7),
  ('dev-q43', 'HTTP status 401 Unauthorized means:', '["The resource was not found","The request was successful","The client must authenticate (provide valid credentials) to access this resource","The server crashed"]', 2, '401 means you are not logged in or your API key is missing/invalid. Not to be confused with 403 Forbidden.', 8),
  ('dev-q43', 'The Content-Type: application/json header tells the server:', '["The size of the request","The file is a JSON document and should be parsed as JSON","The request uses HTTPS","The client is a browser"]', 1, 'Content-Type declares the media type of the request body so the server knows how to parse it.', 9),
  ('dev-q43', 'Compared to XML, JSON is preferred in modern REST APIs because:', '["XML is deprecated","JSON is more verbose","JSON is lighter, easier to read, and maps directly to JavaScript objects","XML cannot represent lists"]', 2, 'JSON is less verbose than XML, natively understood by JavaScript, and has wide library support in all languages.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q44: TypeScript Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q44', 'TypeScript is:', '["A completely separate language from JavaScript","A superset of JavaScript that adds optional static typing","A framework like React","A database query language"]', 1, 'TypeScript extends JavaScript by adding types. Valid JavaScript is valid TypeScript. It compiles down to JS.', 1),
  ('dev-q44', 'The type annotation in: let name: string = "Alex" means:', '["name must always equal ''Alex''","name can only hold string values — TypeScript will error if you assign a number","name is a constant","name is exported"]', 1, 'Type annotations declare what type a variable must hold. TypeScript catches type mismatches at compile time.', 2),
  ('dev-q44', 'What does the tsc command do?', '["Runs TypeScript code directly","Transpiles TypeScript (.ts) files into JavaScript (.js) that browsers can run","Tests TypeScript code","Installs TypeScript packages"]', 1, 'tsc is the TypeScript compiler — it checks types and outputs JavaScript files.', 3),
  ('dev-q44', 'An interface in TypeScript is used to:', '["Import modules","Define the shape (structure) of an object — which properties it has and their types","Create a class","Run async code"]', 1, 'Interfaces describe object shapes: interface User { name: string; age: number; }', 4),
  ('dev-q44', 'A union type like string | number means:', '["The value must be both a string AND a number","The value can be either a string or a number","The value is optional","The value is an array"]', 1, 'Union types allow a variable to hold one of several types — great for flexible function parameters.', 5),
  ('dev-q44', 'Using the any type in TypeScript:', '["Is best practice","Speeds up the code","Disables type checking for that variable, removing TypeScript''s safety benefits — avoid it","Makes the variable global"]', 2, 'any tells TypeScript to ignore type checking. It is an escape hatch — using it defeats the purpose of TypeScript.', 6),
  ('dev-q44', 'An optional property in an interface is written as:', '["name!: string","name?: string","name: string?","?name: string"]', 1, 'The ? after the property name makes it optional: the object may or may not include that property.', 7),
  ('dev-q44', 'TypeScript type inference means:', '["You must always write types explicitly","TypeScript can automatically figure out the type from the value, so you don''t always need annotations","Types are inferred at runtime","The compiler guesses function names"]', 1, 'TypeScript infers types from assignments: let x = 5 automatically gives x the type number.', 8),
  ('dev-q44', 'A .d.ts file is:', '["A deleted TypeScript file","A TypeScript declaration file containing only type information — used to add types to JS libraries","A debug TypeScript file","A deployment configuration"]', 1, 'Declaration files describe the types of external JavaScript libraries so TypeScript knows how to use them.', 9),
  ('dev-q44', 'The never type in TypeScript represents:', '["An optional value","A value that is always undefined","A value that should never occur — used for exhaustive checks and functions that always throw","The void return type"]', 2, 'never is used for functions that throw unconditionally or for unreachable code in exhaustive type checks.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q45: React Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q45', 'React is:', '["A CSS framework","A JavaScript library for building user interfaces from reusable components","A database","A backend web framework"]', 1, 'React (by Facebook/Meta) makes it easy to build complex UIs by composing small, reusable components.', 1),
  ('dev-q45', 'JSX is:', '["A JavaScript XML library","A syntax extension for JavaScript that lets you write HTML-like code inside JavaScript files","A type of JSON","A CSS preprocessor"]', 1, 'JSX looks like HTML in your JS files. React transforms it into regular JavaScript function calls.', 2),
  ('dev-q45', 'A React component is:', '["A CSS class","A database table","A reusable, self-contained piece of UI — a function that returns JSX","A type of loop"]', 2, 'Components are the building blocks of React apps — functions that accept props and return JSX.', 3),
  ('dev-q45', 'A function component in React is a:', '["Class that extends React.Component","Regular JavaScript function that returns JSX","Arrow function that returns CSS","Module that exports HTML"]', 1, 'Modern React uses function components: function Welcome() { return <h1>Hello</h1>; }', 4),
  ('dev-q45', 'In JSX, you write className instead of class because:', '["HTML requires className","class is a reserved keyword in JavaScript, so React uses className to avoid conflicts","className is faster","It is a React tradition"]', 1, 'class is reserved in JS (for defining classes), so JSX uses className for CSS class attributes.', 5),
  ('dev-q45', 'Props in React are:', '["Local state inside a component","CSS properties","Properties passed from a parent component to a child component","Database properties"]', 0, 'Props (properties) are inputs to a component — the parent passes data down via props.', 6),
  ('dev-q45', 'State in a React component is:', '["Data received from the parent via props","Data that the component manages itself and can change over time, causing a re-render","A CSS variable","A permanent database value"]', 1, 'State is dynamic data owned by a component. When state changes, React re-renders the component.', 7),
  ('dev-q45', 'useState(0) returns:', '["Just the number 0","A number and its setter function as an array: [value, setValue]","A string","An object with get and set methods"]', 1, 'useState returns [currentValue, setterFunction]. const [count, setCount] = useState(0) is the typical pattern.', 8),
  ('dev-q45', 'What triggers a component to re-render?', '["Changing a regular variable","Changing state with a setter function (like setCount) or receiving new props","Adding a comment","Importing a new module"]', 1, 'React re-renders a component when its state or props change — regular variable mutations have no effect.', 9),
  ('dev-q45', 'ReactDOM.render() (or createRoot().render()) is used to:', '["Create a new component","Fetch data from an API","Mount the root React component into a real DOM element on the HTML page","Export the React app"]', 2, 'ReactDOM connects React to the browser DOM. It renders your root <App /> component into the #root div.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q46: Testing Basics Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q46', 'A unit test is:', '["A test that checks the entire application end-to-end","A test of a single, isolated piece of code (a function or class) to verify it works correctly","A performance benchmark","A test run by a human"]', 1, 'Unit tests check the smallest units of code in isolation — one function at a time with known inputs.', 1),
  ('dev-q46', 'assertEqual(result, expected) in a test checks that:', '["result is not equal to expected","result equals expected — if not, the test fails","result is a string","Both values are undefined"]', 1, 'assertEqual is a fundamental assertion — it causes the test to fail if the two values are not equal.', 2),
  ('dev-q46', 'A test framework (like pytest or Jest) provides:', '["A way to build web pages","Tools to write, organise, and run tests, and report which pass or fail","A database","A code editor"]', 1, 'Test frameworks give you assertions, test runners, and reports — without one, you would have to check manually.', 3),
  ('dev-q46', 'In TDD, what does the "red" phase mean?', '["The code has an error","You write a failing test before writing any production code","All tests are passing","You deploy the code"]', 1, 'Red = write a test that fails. Green = write code to pass it. Refactor = clean up while keeping tests green.', 4),
  ('dev-q46', 'A test suite is:', '["One individual test","A collection of related tests grouped together","A type of assertion","The test runner program"]', 1, 'A test suite groups related tests — e.g., all tests for the shopping cart module in one suite.', 5),
  ('dev-q46', 'In Python, to create a test class you write:', '["class Test(object)","class TestMyThing(unittest.TestCase)","def test_suite():","test class TestMyThing:"]', 1, 'Python''s unittest requires your test class to extend unittest.TestCase to get all the assertion methods.', 6),
  ('dev-q46', 'Why should you test edge cases?', '["To make tests run faster","Edge cases (empty input, maximum values, zero) are where bugs often hide","They are the easiest cases to test","Edge cases are not important"]', 1, 'Bugs love boundary conditions: empty lists, zero, negative numbers, very long strings. Test them!', 7),
  ('dev-q46', 'A mock object in testing is:', '["A failing test","A real database used for testing","A fake replacement for a dependency (like a network call) that returns controlled values","A test written by someone else"]', 2, 'Mocks simulate external dependencies (APIs, databases) so you can test code in isolation and fast.', 8),
  ('dev-q46', '100% code coverage means:', '["All code is bug-free","Every line of code was executed by at least one test, but it does NOT guarantee correctness","All tests pass","There are no errors"]', 1, 'Coverage shows what code was run, not whether it was tested meaningfully. Good tests matter more than 100%.', 9),
  ('dev-q46', 'A regression test is:', '["A test that always fails","A test that checks a previously fixed bug has not come back","A test for new features","A performance test"]', 1, 'When you fix a bug, write a test for it — this regression test prevents the bug from being reintroduced.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q47: Performance Optimization Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q47', 'LCP (Largest Contentful Paint) measures:', '["How many images are on the page","How long it takes for the largest visible element (image or text block) to render — a key user experience metric","Total page file size","Number of HTTP requests"]', 1, 'LCP measures perceived load speed — when the main content is visible. Under 2.5 seconds is good.', 1),
  ('dev-q47', 'CLS (Cumulative Layout Shift) measures:', '["Page loading speed","Total file size","How much the page layout unexpectedly shifts while loading — poor CLS causes buttons to move as you click","Number of fonts loaded"]', 2, 'CLS scores layout instability. A page that jumps around as it loads scores poorly. Under 0.1 is good.', 2),
  ('dev-q47', 'Minification of JavaScript and CSS means:', '["Making the code run faster at runtime","Removing whitespace, comments, and shortening names to reduce file size","Compressing images","Splitting code into smaller files"]', 1, 'Minification shrinks files (removes spaces/comments) so they download faster. Tools: Terser for JS, cssnano for CSS.', 3),
  ('dev-q47', 'Lazy loading an image means:', '["The image loads in low resolution first","The image only loads when it is about to enter the viewport, saving bandwidth on page load","The image is cached","The image loads twice"]', 1, 'loading="lazy" on <img> defers loading until needed — images below the fold do not load at page start.', 4),
  ('dev-q47', 'A CDN (Content Delivery Network) improves performance by:', '["Compressing all your code","Storing copies of your assets on servers close to users worldwide, reducing latency","Making your database faster","Automatically fixing code bugs"]', 1, 'CDNs serve files from geographically nearby servers — users in Sydney get files from Sydney, not New York.', 5),
  ('dev-q47', 'WebP image format is preferred over PNG for web use because:', '["WebP supports more colours","WebP is universally older","WebP provides significantly smaller file sizes with similar or better quality","WebP loads in parallel"]', 2, 'WebP is a modern format offering 25–35% smaller files than PNG/JPEG at comparable quality, supported by all major browsers.', 6),
  ('dev-q47', 'Browser caching means:', '["The browser blocks all requests","The browser stores copies of files locally so repeat visits do not re-download unchanged files","The browser pre-loads every link","The server caches responses"]', 1, 'Cache-Control headers tell browsers to store assets. Return visits load from disk instead of the network.', 7),
  ('dev-q47', 'A render-blocking resource is:', '["An image that is too large","A CSS or JavaScript file in <head> that must fully download and parse before the browser can render the page","A broken link","A font that is missing"]', 1, 'Render-blocking resources delay the first paint. Move scripts to the bottom or use defer/async to unblock.', 8),
  ('dev-q47', 'Google Lighthouse is a tool that:', '["Deploys your website","Hosts your files","Analyses your web page and scores it on performance, accessibility, SEO, and best practices with actionable tips","Compresses your images automatically"]', 2, 'Lighthouse runs audits in Chrome DevTools or as a CLI — it gives a score and specific recommendations.', 9),
  ('dev-q47', 'The defer attribute on a <script> tag means:', '["The script never runs","The script runs immediately, blocking HTML parsing","The script downloads in parallel with HTML and runs after HTML is fully parsed","The script is optional"]', 2, 'defer downloads the script without blocking parsing, then runs it in order after the DOM is ready — the best default.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q48: Accessibility Advanced Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q48', 'WCAG stands for:', '["Web Content Accessibility Guidelines","Web Coding and Graphics","Website Compliance and Governance","W3C Certified Accessible Guide"]', 0, 'WCAG (published by W3C) defines international standards for making web content accessible to people with disabilities.', 1),
  ('dev-q48', 'WCAG has three conformance levels. What does Level AA mean?', '["The minimum acceptable level","A mid-level target required by most accessibility laws — more inclusive than A but less strict than AAA","The highest possible standard","The level for colour-blind users only"]', 1, 'Level A is minimum, AA is the standard required by most laws (e.g., Section 508, EN 301 549), AAA is aspirational.', 2),
  ('dev-q48', 'The minimum colour contrast ratio for normal-sized body text at WCAG AA is:', '["2:1","3:1","4.5:1","7:1"]', 2, 'WCAG AA requires 4.5:1 contrast for normal text. Large text (18pt+) only needs 3:1. Use a contrast checker tool!', 3),
  ('dev-q48', 'ARIA stands for:', '["Accessible Rich Internet Applications","Advanced Responsive Interface Attributes","Automated Rendering In Accessibility","Adaptive Rich Interaction API"]', 0, 'ARIA provides attributes that add semantic meaning to HTML elements for assistive technologies like screen readers.', 4),
  ('dev-q48', 'aria-label is used to:', '["Style an element","Describe an element to screen readers when there is no visible text label — e.g., an icon button","Set the element''s ID","Control focus order"]', 1, 'aria-label provides an accessible name read by screen readers: <button aria-label="Close menu">×</button>', 5),
  ('dev-q48', 'A "skip navigation" link at the top of the page allows:', '["All users to skip the footer","Keyboard and screen reader users to jump past repeated navigation links directly to the main content","Images to be skipped","Videos to auto-play"]', 1, 'Keyboard users must tab through every nav link on every page without a skip link — that is frustrating and inaccessible.', 6),
  ('dev-q48', 'Focus visible (WCAG 2.4.11) requires:', '["All elements to be focusable","That when an element is focused via keyboard, there is a clearly visible focus indicator — not just the browser default","Focus never moves to interactive elements","Focus rings to be removed for aesthetics"]', 1, 'Many designers hide focus rings with outline: none. This makes keyboard navigation invisible — a critical failure.', 7),
  ('dev-q48', 'A screen reader is:', '["A device that scans printed documents","Assistive technology software that reads web content aloud for users who are blind or have low vision","A browser extension for developers","A monitor with high contrast"]', 1, 'Screen readers (NVDA, JAWS, VoiceOver) convert on-screen text and semantics to speech or braille output.', 8),
  ('dev-q48', 'An image with alt="" (empty alt text) tells a screen reader to:', '["Read the file name of the image","Say ''image''","Skip the image entirely — used for decorative images that add no meaning","Describe the image automatically"]', 2, 'Empty alt tells screen readers the image is decorative and should be ignored — avoids pointless announcements.', 9),
  ('dev-q48', 'Tab order (the order keyboard focus moves through a page) should:', '["Be random","Follow the visual reading order of the page — logical, predictable, left to right, top to bottom","Always start from the footer","Be set manually with tabindex for every element"]', 1, 'A logical tab order matches how sighted users read the page. Avoid tabindex > 0 — it creates confusing custom orders.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q49: Developers Mid-Point Review Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q49', 'JavaScript closures: what does the inner function have access to?', '["Only its own local variables","Only global variables","Its own variables plus those in any outer function scopes where it was defined","Only variables passed as arguments"]', 2, 'A closure is a function that "closes over" variables from its outer scope — even after the outer function has returned.', 1),
  ('dev-q49', 'async/await in JavaScript is used to:', '["Create synchronous code that blocks","Write asynchronous code that reads like synchronous code, using Promises under the hood","Declare global variables","Create CSS animations"]', 1, 'async/await makes async code readable. await pauses execution until the Promise resolves, avoiding callback hell.', 2),
  ('dev-q49', 'document.querySelector("#app") selects:', '["All elements with class app","The element with id app","All app elements","A CSS variable"]', 1, '# in CSS selectors targets id attributes. There should only be one element with any given id per page.', 3),
  ('dev-q49', 'A Python list comprehension [x*2 for x in range(5)] produces:', '["[1, 2, 3, 4, 5]","[0, 2, 4, 6, 8]","[0, 1, 2, 3, 4]","[2, 4, 6, 8, 10]"]', 1, 'range(5) produces 0,1,2,3,4. Multiplying each by 2 gives [0, 2, 4, 6, 8].', 4),
  ('dev-q49', 'In Python OOP, the __init__ method is:', '["Called when a class is imported","Called automatically when a new object is created from the class — used to set initial attributes","A method to delete objects","A class variable"]', 1, '__init__ is the constructor. It runs when you write obj = MyClass() and sets up the object''s initial state.', 5),
  ('dev-q49', 'Python''s with open("file.txt") as f: block ensures:', '["The file is read in binary mode","The file is always closed after the block exits, even if an error occurs","The file cannot be modified","The file is loaded into memory entirely"]', 1, 'The with statement is a context manager — it calls f.close() automatically, preventing resource leaks.', 6),
  ('dev-q49', 'fetch() in JavaScript returns:', '["The response data directly","A Promise that resolves to a Response object","A JSON object","An array of bytes"]', 1, 'fetch() is asynchronous — it returns a Promise. You chain .then() or use await to get the response.', 7),
  ('dev-q49', 'JSON.parse(''{"score":10}'') in JavaScript produces:', '["The string ''{\"score\":10}''","A JavaScript object { score: 10 }","An array","An error"]', 1, 'JSON.parse() converts a JSON string into a JavaScript object. JSON.stringify() does the reverse.', 8),
  ('dev-q49', 'In CSS, the flexbox property justify-content: space-between:', '["Centres items vertically","Adds space inside items","Distributes items so the first is at the start, last at the end, and equal space between the rest","Aligns items to the right"]', 2, 'space-between places equal gaps between flex items, pushing the first to the start and last to the end.', 9),
  ('dev-q49', 'O(n log n) time complexity is typical of:', '["Linear search","Bubble sort","Efficient sorting algorithms like merge sort and Timsort","Hash table lookups"]', 2, 'O(n log n) is the theoretical best possible for comparison-based sorting. Merge sort and Timsort achieve this.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- Q50: Developers Final Assessment Quiz
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('dev-q50', 'What does this JavaScript function do? const add = (a, b) => a + b;', '["Creates a variable named add with value a + b","Defines an arrow function named add that takes two parameters and returns their sum","Declares a class named add","Imports a module called add"]', 1, 'Arrow function shorthand: when the body is a single expression, it is implicitly returned. Equivalent to function add(a, b) { return a + b; }', 1),
  ('dev-q50', 'In Python, what does this class definition add? class Dog: def __init__(self, name): self.name = name', '["Creates a string called Dog","Defines a Dog class where each instance stores a name attribute set at creation","Creates a global variable called name","Defines a function that returns a dog"]', 1, 'self.name = name stores the passed-in name on the instance. Each Dog object will have its own .name attribute.', 2),
  ('dev-q50', 'What is the purpose of async/await in JavaScript compared to raw Promises?', '["async/await is faster than Promises","async/await makes asynchronous code read like synchronous code, improving readability and error handling with try/catch","async/await replaces the need for Promises entirely","async/await only works with fetch()"]', 1, 'async/await is syntactic sugar over Promises. It does not change how code executes, only how it reads — much more clearly.', 3),
  ('dev-q50', 'A REST API endpoint DELETE /posts/7 should:', '["Return post 7","Create a new post with id 7","Delete the post with id 7 and typically return 200 OK or 204 No Content","Update post 7"]', 2, 'DELETE on a specific resource URL removes it. 204 No Content is common as there is nothing to return after deletion.', 4),
  ('dev-q50', 'You have a list of 1,000,000 sorted numbers and need to find one value. Which algorithm is best?', '["Linear search — check every element","Bubble sort — sort then find","Binary search — O(log n), eliminates half the list each step","Hash lookup — O(1)"]', 2, 'For a sorted list, binary search is optimal — it needs only ~20 comparisons for 1,000,000 items. Linear search would need up to 1,000,000.', 5),
  ('dev-q50', 'Your team uses Git. You are building a new feature. What is the correct workflow?', '["Commit directly to main as you go","Create a feature branch, commit there, then open a pull request for review before merging to main","Email your code changes to a colleague","Work in a copy of the repository"]', 1, 'Feature branches keep main stable. Pull requests allow code review before merging — a standard professional practice.', 6),
  ('dev-q50', 'An interactive button built with a <div> instead of <button> is problematic for accessibility because:', '["div elements load slower","div buttons do not have the built-in keyboard focus, Enter/Space activation, and ARIA role that <button> provides","div cannot have click handlers","div elements cannot be styled"]', 1, 'Native <button> elements are focusable, activatable by keyboard, and announced as "button" to screen readers — all for free.', 7),
  ('dev-q50', 'You run your code and see: TypeError: Cannot read properties of undefined (reading ''map''). What is the most likely cause?', '["A loop ran too many times","You called .map() on a variable that is undefined instead of an array — check where the variable is set","A file is missing","A CSS error"]', 1, 'This is the most common React/JS error: the variable you expect to be an array is undefined — often from async data not yet loaded.', 8),
  ('dev-q50', 'In TypeScript, what is the benefit of interface over using any?', '["interface is faster at runtime","interface restricts the type to a specific shape, catching errors at compile time; any removes all type safety","interface auto-generates documentation","interface is required for all functions"]', 1, 'TypeScript''s value is catching errors before runtime. Using any for objects you understand throws away that protection.', 9),
  ('dev-q50', 'When planning a new web application, why should you separate concerns into frontend, backend, and database layers?', '["It makes the app run faster automatically","Each layer can be developed, tested, scaled, and replaced independently — a backend change does not require rewriting the UI","It is required by all browsers","It makes the code shorter"]', 1, 'Separation of concerns is a fundamental software architecture principle — it makes systems maintainable and scalable over time.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;
