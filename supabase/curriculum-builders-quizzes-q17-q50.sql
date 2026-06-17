-- =============================================================================
-- CODEship Academy — Builders Quizzes Q17–Q50
-- Ages 9–11 | Transitioning from Scratch blocks to JavaScript text code
-- 34 quizzes × 10 questions = 340 questions
-- =============================================================================

INSERT INTO quizzes (slug, title, level, category, time_limit_seconds, passing_score, xp_reward) VALUES
('bld-q17', 'HTML Basics Quiz',              'builders', 'HTML',               600, 70, 150),
('bld-q18', 'HTML Elements Quiz',            'builders', 'HTML',               600, 70, 150),
('bld-q19', 'CSS Selectors Quiz',            'builders', 'CSS',                600, 70, 150),
('bld-q20', 'CSS Properties Quiz',           'builders', 'CSS',                600, 70, 150),
('bld-q21', 'CSS Colors and Fonts Quiz',     'builders', 'CSS',                600, 70, 150),
('bld-q22', 'CSS Box Model Quiz',            'builders', 'CSS',                600, 70, 150),
('bld-q23', 'JavaScript Introduction Quiz',  'builders', 'JavaScript',         600, 70, 150),
('bld-q24', 'JavaScript Variables Quiz',     'builders', 'JavaScript',         600, 70, 150),
('bld-q25', 'JavaScript Data Types Quiz',    'builders', 'JavaScript',         600, 70, 150),
('bld-q26', 'JavaScript Operators Quiz',     'builders', 'JavaScript',         600, 70, 150),
('bld-q27', 'JavaScript Conditionals Quiz',  'builders', 'JavaScript',         600, 70, 150),
('bld-q28', 'JavaScript Functions Quiz',     'builders', 'JavaScript',         600, 70, 150),
('bld-q29', 'JavaScript Loops Quiz',         'builders', 'JavaScript',         600, 70, 150),
('bld-q30', 'JavaScript Arrays Quiz',        'builders', 'JavaScript',         600, 70, 150),
('bld-q31', 'JavaScript Objects Quiz',       'builders', 'JavaScript',         600, 70, 150),
('bld-q32', 'JavaScript DOM Basics Quiz',    'builders', 'JavaScript',         600, 70, 150),
('bld-q33', 'JavaScript Events Quiz',        'builders', 'JavaScript',         600, 70, 150),
('bld-q34', 'JavaScript Strings Quiz',       'builders', 'JavaScript',         600, 70, 150),
('bld-q35', 'CSS Flexbox Quiz',              'builders', 'CSS',                600, 70, 150),
('bld-q36', 'CSS Animations Quiz',           'builders', 'CSS',                600, 70, 150),
('bld-q37', 'Web Accessibility Basics Quiz', 'builders', 'Accessibility',      600, 70, 150),
('bld-q38', 'Browser DevTools Quiz',         'builders', 'Tools',              600, 70, 150),
('bld-q39', 'JavaScript Mini-Project Quiz',  'builders', 'JavaScript',         600, 70, 150),
('bld-q40', 'HTML Forms Quiz',               'builders', 'HTML',               600, 70, 150),
('bld-q41', 'JavaScript Math Quiz',          'builders', 'JavaScript',         600, 70, 150),
('bld-q42', 'JavaScript Debugging Quiz',     'builders', 'JavaScript',         600, 70, 150),
('bld-q43', 'Web Performance Basics Quiz',   'builders', 'Tools',              600, 70, 150),
('bld-q44', 'CSS Responsive Design Quiz',    'builders', 'CSS',                600, 70, 150),
('bld-q45', 'JavaScript ES6 Basics Quiz',    'builders', 'JavaScript',         600, 70, 150),
('bld-q46', 'JavaScript Promises Basics Quiz','builders', 'JavaScript',        600, 70, 150),
('bld-q47', 'Web APIs Basics Quiz',          'builders', 'APIs',               600, 70, 150),
('bld-q48', 'Builders Mid-Point Review Quiz','builders', 'Review',             600, 70, 150),
('bld-q49', 'Builders Project Planning Quiz','builders', 'Projects',           600, 70, 150),
('bld-q50', 'Builders Final Assessment Quiz','builders', 'Review',             600, 70, 150)
ON CONFLICT (slug) DO NOTHING;

-- =============================================================================
-- Q17: HTML Basics Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q17', 'What does HTML stand for?', '["HyperText Markup Language","HyperText Machine Language","HighText Making Language","HyperText Modern Language"]', 0, 'HTML stands for HyperText Markup Language — it is the standard language for creating web pages.', 1),
  ('bld-q17', 'Which tag is used to make the BIGGEST heading on a page?', '["<h6>","<heading>","<h1>","<big>"]', 2, '<h1> is the largest and most important heading. Headings go from <h1> (biggest) to <h6> (smallest).', 2),
  ('bld-q17', 'Where does visible page content go in HTML?', '["<head>","<body>","<html>","<meta>"]', 1, 'Everything you see on a web page goes inside the <body> tag. The <head> holds invisible information.', 3),
  ('bld-q17', 'Which tag creates a paragraph of text?', '["<para>","<text>","<pg>","<p>"]', 3, 'The <p> tag creates a paragraph. It adds space above and below the text automatically.', 4),
  ('bld-q17', 'How do you write a comment in HTML?', '["// This is a comment","/* This is a comment */","<!-- This is a comment -->","## This is a comment"]', 2, 'HTML comments use the special <!-- --> syntax. The browser ignores everything between those markers.', 5),
  ('bld-q17', 'What does the <title> tag do?', '["Creates a big title on the page","Sets the text shown in the browser tab","Makes text bold","Creates a header area"]', 1, 'The <title> tag sets the text that appears in the browser tab and when you bookmark the page.', 6),
  ('bld-q17', 'Which tag creates a clickable link?', '["<link>","<url>","<a>","<href>"]', 2, 'The <a> (anchor) tag creates hyperlinks. The href attribute sets where the link goes.', 7),
  ('bld-q17', 'HTML tags are written inside which symbols?', '["( )","{ }","[ ]","< >"]', 3, 'HTML tags use angle brackets < and >. For example: <p>, <h1>, <body>.', 8),
  ('bld-q17', 'Which tag adds an image to a page?', '["<image>","<img>","<pic>","<photo>"]', 1, 'The <img> tag embeds an image. It uses the src attribute to point to the image file.', 9),
  ('bld-q17', 'What is the correct structure for a basic HTML page?', '["<body> inside <head>","<html> contains <head> and <body>","<head> contains everything","<body> is the root element"]', 1, 'A proper HTML page has <html> as the root, with <head> (invisible info) and <body> (visible content) inside it.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q18: HTML Elements Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q18', 'Which tag creates a bulleted (unordered) list?', '["<ol>","<list>","<ul>","<li>"]', 2, '<ul> stands for Unordered List and creates bullet points. <ol> creates a numbered list.', 1),
  ('bld-q18', 'What does <li> stand for?', '["Line item","Large image","List item","Link inside"]', 2, '<li> stands for List Item. It goes inside <ul> or <ol> to create each item in the list.', 2),
  ('bld-q18', 'Which tag makes text appear bold and important?', '["<b>","<bold>","<strong>","<em>"]', 2, '<strong> makes text bold AND tells screen readers it is important. <b> is just visual bold with no meaning.', 3),
  ('bld-q18', 'Which tag makes text italic and emphasized?', '["<italic>","<i>","<slant>","<em>"]', 3, '<em> adds emphasis (displays as italic) and has meaning for screen readers. <i> is just visual italic.', 4),
  ('bld-q18', 'What does a <br> tag do?', '["Creates a border","Breaks to a new line","Makes text bold and red","Creates a button"]', 1, '<br> inserts a line break inside text without starting a whole new paragraph.', 5),
  ('bld-q18', 'Which HTML tag is used for a navigation menu?', '["<menu>","<navbar>","<nav>","<links>"]', 2, '<nav> is a semantic HTML5 tag that marks a navigation section. It tells browsers and screen readers this is the site navigation.', 6),
  ('bld-q18', 'What is a "self-closing" tag?', '["A tag that closes itself, like <br> or <img>","A tag that closes other tags","A tag with no attributes","A tag that hides content"]', 0, 'Self-closing (void) tags like <br>, <img>, and <input> do not need a separate closing tag because they cannot contain content.', 7),
  ('bld-q18', 'Which tag creates a table row?', '["<td>","<tr>","<th>","<table>"]', 1, '<tr> stands for Table Row. Inside it, <td> creates regular cells and <th> creates header cells.', 8),
  ('bld-q18', 'What does the alt attribute on an <img> tag do?', '["Sets the image size","Changes the image colour","Describes the image for accessibility","Links to another image"]', 2, 'The alt attribute provides alternative text for an image. Screen readers read it aloud, and it shows if the image fails to load.', 9),
  ('bld-q18', 'Which tag is used for the main content area of a page (not sidebar or nav)?', '["<section>","<main>","<article>","<div>"]', 1, '<main> marks the primary content of the page. There should be only one <main> per page, and it should not include nav, headers, or footers.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q19: CSS Selectors Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q19', 'How do you select ALL <p> tags in CSS?', '[".p","#p","p","*p"]', 2, 'To select by element type, just write the tag name without any symbol: p { }', 1),
  ('bld-q19', 'How do you select an element with class="highlight"?', '["highlight","#highlight",".highlight","*highlight"]', 2, 'Class selectors use a dot (.) before the class name: .highlight { }', 2),
  ('bld-q19', 'How do you select an element with id="header"?', '[".header","#header","header","*header"]', 1, 'ID selectors use a hash (#) before the ID name: #header { }', 3),
  ('bld-q19', 'What does the * selector do in CSS?', '["Selects all links","Selects starred elements","Selects everything on the page","Selects nothing"]', 2, 'The * (universal selector) selects EVERY element on the page. It is often used to reset margins and padding.', 4),
  ('bld-q19', 'Which selector picks <p> tags INSIDE a <div>?', '["p > div","div + p","div p","p, div"]', 2, '"div p" is a descendant selector — it selects any <p> that is anywhere inside a <div>, no matter how deep.', 5),
  ('bld-q19', 'What does a:hover do?', '["Selects all <a> tags","Styles a link when the mouse is over it","Hides all links","Makes links jump"]', 1, 'The :hover pseudo-class applies styles when the user''s mouse hovers over an element.', 6),
  ('bld-q19', 'Which selector picks ONLY <p> tags that are direct children of <div>?', '["div p","div > p","div + p","div, p"]', 1, 'The > symbol is the direct child combinator. "div > p" only selects <p> elements that are immediate children of <div>.', 7),
  ('bld-q19', 'How do you apply the same styles to both h1 AND h2?', '["h1 h2","h1 > h2","h1 + h2","h1, h2"]', 3, 'A comma-separated list applies the same rules to multiple selectors: h1, h2 { }', 8),
  ('bld-q19', 'Which selector targets an input when it is focused (clicked into)?', '["input:active","input:focus","input:hover","input:selected"]', 1, ':focus applies when an element is focused — usually when a user clicks an input field or tabs to it.', 9),
  ('bld-q19', 'What does p:first-child mean?', '["The first <p> on the page","A <p> that is the first child of its parent","The first word in a <p>","All <p> tags"]', 1, ':first-child selects an element that is the very first child inside its parent container.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q20: CSS Properties Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q20', 'Which CSS property changes the text colour?', '["font-color","text-color","color","foreground"]', 2, 'The "color" property sets the text colour. For background colour, use "background-color".', 1),
  ('bld-q20', 'Which property sets the background colour?', '["background","bg-color","color","background-color"]', 3, 'background-color sets the fill colour behind an element. You can also use background for shorthand.', 2),
  ('bld-q20', 'Which property changes how big the text is?', '["text-size","font-size","size","letter-size"]', 1, 'font-size controls how large text appears. Common values are pixels (16px), em (1.2em), or rem.', 3),
  ('bld-q20', 'Which property makes text bold?', '["text-weight","bold","font-weight","font-bold"]', 2, 'font-weight controls the thickness of text. Values include "bold", "normal", and numbers like 700.', 4),
  ('bld-q20', 'Which property adds space INSIDE an element''s border?', '["margin","space","padding","border-space"]', 2, 'Padding is the space between the content and the element''s border. Margin is the space OUTSIDE the border.', 5),
  ('bld-q20', 'Which property adds space OUTSIDE an element?', '["padding","margin","border","spacing"]', 1, 'Margin creates space around the outside of an element, pushing other elements away from it.', 6),
  ('bld-q20', 'Which property adds a line around an element?', '["outline","frame","border","edge"]', 2, 'The border property draws a line around an element. Example: border: 2px solid black;', 7),
  ('bld-q20', 'Which property controls the stacking order of overlapping elements?', '["stack-order","layer","z-index","position"]', 2, 'z-index controls which element appears on top when elements overlap. Higher numbers appear in front.', 8),
  ('bld-q20', 'Which property hides an element but still takes up space?', '["display: none","visibility: hidden","opacity: 0","hidden: true"]', 1, 'visibility: hidden hides an element visually but it still takes up space. display: none removes it completely.', 9),
  ('bld-q20', 'Which property rounds the corners of an element?', '["corner-radius","round-corners","border-radius","rounded"]', 2, 'border-radius rounds the corners of an element. A value of 50% on a square makes it a circle.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q21: CSS Colors and Fonts Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q21', 'Which of these is a valid CSS colour name?', '["lightblue","light-blue","LIGHTBLUE","light_blue"]', 0, 'CSS has 140+ named colours like red, blue, coral, lightblue. They are lowercase with no spaces or hyphens for most.', 1),
  ('bld-q21', 'What does # mean at the start of a colour value like #ff0000?', '["It is a comment","It marks an ID","It means the colour is in hex format","It is a shortcut key"]', 2, 'A # symbol before a colour means it is a hexadecimal (hex) colour code. #ff0000 is red.', 2),
  ('bld-q21', 'In the colour rgb(255, 0, 0), what does the first number control?', '["Blue","Green","Brightness","Red"]', 3, 'RGB stands for Red, Green, Blue. The numbers go in that order: rgb(red, green, blue). 255 is maximum, 0 is none.', 3),
  ('bld-q21', 'Which CSS property sets the font family (typeface)?', '["font-style","typeface","font-family","text-font"]', 2, 'font-family sets the typeface. Example: font-family: Arial, sans-serif; The second value is a fallback.', 4),
  ('bld-q21', 'What does font-style: italic do?', '["Makes text bold","Makes text slanted/italic","Changes the font size","Underlines text"]', 1, 'font-style: italic makes text lean to the right (italic). font-style: normal turns it back to upright.', 5),
  ('bld-q21', 'Which property adds an underline to text?', '["text-style: underline","font-decoration: underline","text-decoration: underline","underline: true"]', 2, 'text-decoration: underline adds an underline. You can also use text-decoration: none to remove underlines from links.', 6),
  ('bld-q21', 'What is rgba(0, 0, 255, 0.5)?', '["Solid blue","Half-transparent blue","Full green","Invalid colour"]', 1, 'rgba() is like rgb() but with a 4th value for alpha (transparency). 0 is invisible, 1 is fully solid. 0.5 is half-transparent.', 7),
  ('bld-q21', 'Which value makes text UPPERCASE without changing the HTML?', '["font-case: upper","text-transform: uppercase","font-style: uppercase","text-style: caps"]', 1, 'text-transform: uppercase makes text display in capital letters using CSS, without editing the HTML content.', 8),
  ('bld-q21', 'What does line-height control?', '["The height of capital letters","The space between lines of text","The size of the font","The width of each letter"]', 1, 'line-height controls the space between lines of text. A value of 1.5 means 150% of the font size.', 9),
  ('bld-q21', 'Which property controls the space between individual letters?', '["word-spacing","letter-spacing","font-spacing","text-tracking"]', 1, 'letter-spacing adds or removes space between individual characters. Positive values spread letters apart.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q22: CSS Box Model Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q22', 'What are the four layers of the CSS box model from inside to outside?', '["Content, Border, Padding, Margin","Content, Padding, Border, Margin","Margin, Border, Padding, Content","Padding, Content, Margin, Border"]', 1, 'The box model layers from inside to outside are: Content → Padding → Border → Margin.', 1),
  ('bld-q22', 'What does "padding: 10px 20px" mean?', '["10px all sides","10px top/bottom, 20px left/right","20px top/bottom, 10px left/right","10px left/right, 20px top/bottom"]', 1, 'When padding has two values, the first is top and bottom, the second is left and right: padding: top/bottom left/right.', 2),
  ('bld-q22', 'What does "margin: auto" do to a block element?', '["Removes all margins","Adds automatic random margin","Centers the element horizontally","Sets margin to 10px"]', 2, 'margin: auto on a block element with a set width centers it horizontally by splitting the remaining space equally.', 3),
  ('bld-q22', 'By default, does "width: 200px" include padding and border?', '["Yes, always","No, padding and border are added on top","Only for divs","Only if you set height too"]', 1, 'By default (content-box), width does NOT include padding or border — they are added on top, making the element wider.', 4),
  ('bld-q22', 'What does "box-sizing: border-box" do?', '["Adds a border","Makes width include padding and border","Removes the box model","Centers the content"]', 1, 'border-box makes the width and height include padding and border, so the element stays the exact size you set.', 5),
  ('bld-q22', 'What does "padding: 5px 10px 15px 20px" mean?', '["All sides 5px","Top 5px, Right 10px, Bottom 15px, Left 20px","Top 20px, Right 15px, Bottom 10px, Left 5px","Equal padding on all sides"]', 1, 'Four values go clockwise: Top, Right, Bottom, Left (think TRouBLe — TRBL).', 6),
  ('bld-q22', 'Which property controls the space between the content and the border?', '["margin","spacing","padding","gap"]', 2, 'Padding is the space between the content and the border. Think of it like cushioning inside a box.', 7),
  ('bld-q22', 'What is "margin collapse"?', '["Margins disappearing completely","When two vertical margins meet, only the larger one is used","When margin equals padding","When an element has no margin"]', 1, 'When two block elements'' vertical margins touch, they collapse into one — the larger margin wins instead of adding together.', 8),
  ('bld-q22', 'Which shorthand property sets all four sides of border at once?', '["border: width style color","border-all: 1px solid red","border-sides: 1px","all-border: solid"]', 0, 'The border shorthand sets width, style, and colour: border: 2px solid blue; This applies to all four sides.', 9),
  ('bld-q22', 'If an element has width: 100px, padding: 10px, and border: 5px, what is its total width with default box-sizing?', '["100px","115px","130px","120px"]', 2, 'With content-box (default): total width = 100 + 10 + 10 (both sides padding) + 5 + 5 (both sides border) = 130px.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q23: JavaScript Introduction Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q23', 'What is JavaScript mainly used for on websites?', '["Creating page structure","Styling with colours","Making pages interactive","Storing data in databases"]', 2, 'JavaScript makes web pages interactive — it responds to clicks, changes content, validates forms, and fetches data.', 1),
  ('bld-q23', 'How do you write a single-line comment in JavaScript?', '["<!-- comment -->","/* comment */","// comment","# comment"]', 2, 'JavaScript single-line comments start with //. Everything after // on that line is ignored by the browser.', 2),
  ('bld-q23', 'Which method prints a message to the browser console?', '["print()","log()","console.log()","alert.log()"]', 2, 'console.log() is the main way to print messages during development. Press F12 to see the console.', 3),
  ('bld-q23', 'Where can you write JavaScript in an HTML file?', '["Inside <style> tags","Inside <script> tags","Inside <js> tags","Inside <code> tags"]', 1, 'JavaScript goes inside <script> tags, which can be placed at the bottom of the <body> or in the <head>.', 4),
  ('bld-q23', 'What does alert("Hello") do?', '["Prints to the console","Changes page content","Shows a pop-up message box","Sends an email"]', 1, 'alert() shows a pop-up dialog box with your message. The user must click OK to dismiss it.', 5),
  ('bld-q23', 'Which of these is a correct JavaScript statement?', '["console.log["Hello"]","console.log(Hello)","console.log(''Hello'')","Console.Log(''Hello'')"]', 2, 'console.log() takes arguments in parentheses. Strings need quotes. JavaScript is case-sensitive, so console.log not Console.Log.', 6),
  ('bld-q23', 'What happens if JavaScript finds an error in your code?', '["The browser crashes","The rest of the script may stop running","The page turns red","Nothing happens"]', 1, 'A JavaScript error usually stops that script from continuing. Other scripts on the page may still work.', 7),
  ('bld-q23', 'JavaScript was created to run inside what?', '["Desktop apps","Web browsers","Database servers","Video games"]', 1, 'JavaScript was originally created to run inside web browsers to make websites interactive.', 8),
  ('bld-q23', 'Which symbol ends a JavaScript statement?', '["A full stop .","A colon :","A semicolon ;","A comma ,"]', 2, 'Semicolons ; end JavaScript statements. They are often optional but it is good practice to include them.', 9),
  ('bld-q23', 'What does the browser console show you?', '["Only error messages","Only the HTML","Messages from console.log() and errors","The CSS styles"]', 2, 'The browser console shows console.log() output, errors, warnings, and lets you type JS to test it live.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q24: JavaScript Variables Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q24', 'Which keyword creates a variable that can be changed later?', '["const","var","let","set"]', 2, 'let creates a variable that can be reassigned. const creates one that cannot be changed after creation.', 1),
  ('bld-q24', 'Which keyword creates a variable that CANNOT be changed?', '["let","var","fixed","const"]', 3, 'const stands for constant. Once you set it, you cannot reassign it to a different value.', 2),
  ('bld-q24', 'What is the value of x after: const x = 5 + 3?', '["53","5","3","8"]', 3, 'JavaScript calculates 5 + 3 = 8 before storing it. So x holds the number 8.', 3),
  ('bld-q24', 'Which variable name follows JavaScript naming rules?', '["2score","my-score","my_score","class"]', 2, 'Variable names can have letters, numbers, underscores, and $. They cannot start with a number or be reserved words like "class".', 4),
  ('bld-q24', 'What does this code do? let name = "Alex";', '["Creates a number variable","Creates a variable called name holding the text Alex","Prints Alex to the screen","Creates a function"]', 1, 'This declares a variable called name and assigns it the string value "Alex". Strings use quotes.', 5),
  ('bld-q24', 'What happens when you try to change a const variable?', '["It changes fine","Nothing happens","JavaScript throws an error","It creates a new variable"]', 2, 'Trying to reassign a const variable causes a TypeError. const values are locked after they are set.', 6),
  ('bld-q24', 'What is "variable declaration"?', '["Using a variable in a calculation","Creating a variable for the first time","Printing a variable","Deleting a variable"]', 1, 'Declaration is when you first create a variable with let, const, or var — it introduces the variable to JavaScript.', 7),
  ('bld-q24', 'What is stored in the variable? let score = 0;', '["The text "0"","The number zero","Nothing","The word score"]', 1, 'Without quotes, 0 is a number. With quotes ("0") it would be a string. Here score holds the number 0.', 8),
  ('bld-q24', 'Which of these correctly reassigns a let variable?', '["let age = 12; let age = 13;","let age = 12; const age = 13;","let age = 12; age = 13;","let age = 12; var age = 13;"]', 2, 'To change a let variable, just write the name and new value without the keyword: age = 13;', 9),
  ('bld-q24', 'Why are meaningful variable names important?', '["They make code run faster","They make code easier to read and understand","JavaScript requires long names","They save memory"]', 1, 'Good names like playerScore or userName make code readable. Names like x or a1b2 are hard to understand later.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q25: JavaScript Data Types Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q25', 'What data type is the value "Hello, World!"?', '["Number","Boolean","String","Undefined"]', 2, 'Text values in quotes are strings. Strings can use single quotes, double quotes, or backticks.', 1),
  ('bld-q25', 'What data type is the value 42?', '["String","Number","Boolean","Object"]', 1, '42 without quotes is a number. JavaScript uses "number" for both integers (42) and decimals (3.14).', 2),
  ('bld-q25', 'Which of these is a Boolean value?', '["Yes","1","true","on"]', 2, 'Booleans are only true or false (lowercase). They are used for yes/no decisions in code.', 3),
  ('bld-q25', 'What does "undefined" mean in JavaScript?', '["The value is 0","A variable exists but has no value yet","An error occurred","The value is empty text"]', 1, 'undefined means a variable was created but never given a value. It is JavaScript''s way of saying "nothing assigned yet".', 4),
  ('bld-q25', 'What is the result of typeof "hello"?', '["string","text","String","word"]', 0, 'typeof is an operator that tells you a value''s type. typeof "hello" returns the string "string".', 5),
  ('bld-q25', 'What is the difference between 5 and "5"?', '["Nothing — they are the same","5 is a number, \"5\" is a string","\"5\" is larger","5 is a boolean"]', 1, '5 without quotes is a number (can do maths). "5" with quotes is a string (text). 5 + 5 = 10 but "5" + "5" = "55".', 6),
  ('bld-q25', 'What data type is an empty string ""?', '["Null","Undefined","Boolean","String"]', 3, 'An empty string "" is still a string data type — it just has no characters in it. It is not null or undefined.', 7),
  ('bld-q25', 'What is null in JavaScript?', '["Same as undefined","An intentional empty value","A type of number","A boolean"]', 1, 'null means "intentionally no value". Developers set something to null on purpose, unlike undefined which happens automatically.', 8),
  ('bld-q25', 'What is the result of typeof true?', '["boolean","Boolean","bool","true"]', 0, 'typeof true returns "boolean". Note typeof always returns a lowercase string.', 9),
  ('bld-q25', 'Which data type would you use to store a person''s age?', '["String","Boolean","Number","Undefined"]', 2, 'Ages are whole numbers, so Number is the correct data type. If you store it as a string you cannot do maths with it.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q26: JavaScript Operators Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q26', 'What does the + operator do with two numbers?', '["Joins them as text","Subtracts them","Adds them together","Multiplies them"]', 2, 'With two numbers, + adds them: 3 + 5 = 8. With two strings, + joins them: "Hello" + " World" = "Hello World".', 1),
  ('bld-q26', 'What is the result of 10 % 3?', '["3","1","0","30"]', 1, 'The % operator gives the remainder after division. 10 divided by 3 is 3 remainder 1, so 10 % 3 = 1.', 2),
  ('bld-q26', 'What does === mean in JavaScript?', '["Assign a value","Strictly equal (same value AND same type)","Greater than or equal","Roughly equal"]', 1, '=== checks that both value AND type match. 5 === "5" is false because one is a number and one is a string.', 3),
  ('bld-q26', 'What is the result of "Hello" + " " + "World"?', '["Hello World","HelloWorld","Hello + World","Error"]', 0, 'The + operator joins strings together. "Hello" + " " + "World" produces "Hello World".', 4),
  ('bld-q26', 'Which operator means "NOT equal to" (strict)?', '["!=","<>","!==","=#"]', 2, '!== checks that values are NOT strictly equal. 5 !== "5" is true because they are different types.', 5),
  ('bld-q26', 'What does score++ do?', '["Multiplies score by itself","Decreases score by 1","Increases score by 1","Doubles score"]', 2, '++ is the increment operator. score++ is shorthand for score = score + 1. It adds 1 to the variable.', 6),
  ('bld-q26', 'What is the result of 2 ** 3?', '["5","6","8","23"]', 2, '** is the exponentiation operator. 2 ** 3 means 2 to the power of 3 = 2 × 2 × 2 = 8.', 7),
  ('bld-q26', 'What does the && operator mean?', '["OR — at least one must be true","NOT — flips true to false","AND — both must be true","EQUALS — same value"]', 2, '&& means AND. Both conditions must be true for the whole expression to be true: (age > 10 && age < 18).', 8),
  ('bld-q26', 'What is the result of !true?', '["true","undefined","false","null"]', 2, 'The ! (NOT) operator flips a boolean. !true = false, !false = true.', 9),
  ('bld-q26', 'What does x += 5 mean?', '["x equals 5","x plus 5 equals x","x = x + 5","x = 5 + x + x"]', 2, '+= is a compound assignment operator. x += 5 is shorthand for x = x + 5. It adds 5 to x''s current value.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q27: JavaScript Conditionals Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q27', 'What keyword starts a conditional statement in JavaScript?', '["when","if","check","case"]', 1, 'The if keyword starts a conditional. The code inside the {} runs only if the condition is true.', 1),
  ('bld-q27', 'What does "else" do in an if/else statement?', '["Runs if the if condition is true","Runs only sometimes","Runs if the if condition is false","Always runs"]', 2, 'else provides an alternative block of code that runs when the if condition is false.', 2),
  ('bld-q27', 'What does "else if" allow you to do?', '["End a conditional","Check a second condition if the first was false","Run code always","Loop through conditions"]', 1, 'else if lets you check another condition if the previous if was false. You can chain many else if blocks.', 3),
  ('bld-q27', 'Which comparison operator means "greater than or equal to"?', '[">>","=>",">=","==>"]', 2, '>= means greater than or equal to. 10 >= 10 is true, and 11 >= 10 is also true.', 4),
  ('bld-q27', 'What will this code print? if (5 > 3) { console.log("yes"); }', '["no","nothing","yes","error"]', 2, '5 > 3 is true, so the code inside the {} runs and prints "yes".', 5),
  ('bld-q27', 'In a conditional, the condition goes inside:', '["{ }","[ ]","( )","< >"]', 2, 'The condition goes inside parentheses: if (condition) { }. The code to run goes inside the curly braces.', 6),
  ('bld-q27', 'What is a "nested if" statement?', '["An if inside another if","An if with no else","An if that runs twice","An if that is always true"]', 0, 'A nested if is an if statement placed inside another if or else block, allowing more complex decision trees.', 7),
  ('bld-q27', 'What does this code do? let score = 85; if (score >= 90) { ... } else if (score >= 70) { ... } else { ... }', '["Always runs the first block","Runs the second block (score >= 70)","Runs the else block","Causes an error"]', 1, '85 is not >= 90, but it is >= 70, so the second block (else if) runs.', 8),
  ('bld-q27', 'What is the ternary operator?', '["A shorthand for if/else: condition ? value1 : value2","A three-way equals sign","A loop that runs three times","A way to create three variables"]', 0, 'The ternary operator is a compact if/else: let result = (score > 50) ? "pass" : "fail";', 9),
  ('bld-q27', 'What does switch() do in JavaScript?', '["Flips a boolean","Checks one value against many possible cases","Creates a loop","Defines a function"]', 1, 'switch() compares a single value to multiple cases. It is cleaner than many else if statements for fixed options.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q28: JavaScript Functions Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q28', 'What is a function in JavaScript?', '["A type of variable","A reusable block of code with a name","A type of loop","A way to style elements"]', 1, 'A function is a named, reusable block of code. You define it once and can call it many times.', 1),
  ('bld-q28', 'Which keyword defines a function?', '["func","def","function","create"]', 2, 'The function keyword defines a function: function myFunction() { }', 2),
  ('bld-q28', 'How do you call (run) a function called greet?', '["function greet","greet{}","run greet","greet()"]', 3, 'You call a function by writing its name followed by parentheses: greet(). The () tells JavaScript to run it.', 3),
  ('bld-q28', 'What are parameters in a function?', '["The code inside the function","Variables that receive values when the function is called","The function''s name","The return value"]', 1, 'Parameters are variables listed in the function definition: function add(a, b) — a and b are parameters.', 4),
  ('bld-q28', 'What does the return keyword do?', '["Prints a value","Stops the page","Sends a value back from the function","Repeats the function"]', 2, 'return sends a value back to wherever the function was called. After return, the function stops running.', 5),
  ('bld-q28', 'What is the output? function double(n) { return n * 2; } console.log(double(5));', '["5","10","double(5)","undefined"]', 1, 'double(5) calls the function with n=5. It returns 5 * 2 = 10. console.log then prints 10.', 6),
  ('bld-q28', 'What is an arrow function?', '["A function that loops","A shorthand way to write functions using =>","A function that points to an element","A function that returns nothing"]', 1, 'Arrow functions are a shorter syntax: const add = (a, b) => a + b; They use => instead of the function keyword.', 7),
  ('bld-q28', 'What is the difference between parameters and arguments?', '["They are the same thing","Parameters are in the definition; arguments are the actual values passed when calling","Arguments are in the definition","Parameters are only for arrow functions"]', 1, 'Parameters are the placeholders in the function definition. Arguments are the real values you pass when you call it.', 8),
  ('bld-q28', 'What does a function return if it has no return statement?', '["0","false","null","undefined"]', 3, 'If a function has no return statement (or just return;), it automatically returns undefined.', 9),
  ('bld-q28', 'Why are functions useful?', '["They make code slower","They let you reuse code without repeating it","They are required by HTML","They replace variables"]', 1, 'Functions let you write a block of code once and reuse it many times. This avoids repetition and makes code easier to fix.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q29: JavaScript Loops Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q29', 'What does a loop do in JavaScript?', '["Runs code once","Stops the script","Repeats code a set number of times or while a condition is true","Jumps to a function"]', 2, 'Loops repeat a block of code — either a set number of times or as long as a condition stays true.', 1),
  ('bld-q29', 'What are the three parts of a for loop?', '["Start, middle, end","Initialise, condition, update","Variable, function, return","Open, run, close"]', 1, 'A for loop has: initialise (let i = 0), condition (i < 5), and update (i++) — all in the parentheses.', 2),
  ('bld-q29', 'How many times does this loop run? for (let i = 0; i < 5; i++) {}', '["4","6","5","0"]', 2, 'The loop runs while i < 5. i goes 0, 1, 2, 3, 4 — that is 5 times.', 3),
  ('bld-q29', 'What is a "while" loop?', '["A loop that runs a fixed number of times","A loop that runs as long as a condition is true","A loop that always runs once","A loop inside a function"]', 1, 'A while loop runs its code block over and over as long as its condition stays true: while (score < 100) { }', 4),
  ('bld-q29', 'What is an infinite loop?', '["A loop that runs exactly once","A loop that never stops because the condition is always true","A loop with no code inside","A loop that skips every other item"]', 1, 'An infinite loop never ends because its condition never becomes false. This freezes the browser, so always make sure your loop can stop.', 5),
  ('bld-q29', 'What does "break" do inside a loop?', '["Pauses the loop","Restarts the loop","Immediately exits the loop","Skips the current iteration"]', 2, 'break immediately exits the loop, even if the condition is still true. Useful for stopping when you find what you need.', 6),
  ('bld-q29', 'What does "continue" do inside a loop?', '["Exits the loop","Skips the rest of the current iteration and goes to the next one","Restarts the loop from the beginning","Doubles the loop speed"]', 1, 'continue skips the remaining code in the current loop iteration and jumps to the next iteration.', 7),
  ('bld-q29', 'What is a for...of loop best used for?', '["Counting from 1 to 10","Looping through each item in an array","Checking a condition","Defining functions"]', 1, 'for...of iterates directly over array items: for (const item of fruits) { } — much cleaner than index-based loops.', 8),
  ('bld-q29', 'What does i++ do in a for loop?', '["Sets i to 0","Prints i","Increases i by 1 after each iteration","Decreases i by 1"]', 2, 'i++ increments i by 1 each time the loop body finishes. Without this update, the loop would run forever.', 9),
  ('bld-q29', 'Which loop is guaranteed to run at least once?', '["for loop","while loop","do...while loop","for...of loop"]', 2, 'A do...while loop runs its code first, then checks the condition. So it always executes at least one time.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q30: JavaScript Arrays Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q30', 'What is an array in JavaScript?', '["A single value","An ordered list of values in square brackets","A type of function","A CSS property"]', 1, 'An array stores multiple values in order: const fruits = ["apple", "banana", "cherry"];', 1),
  ('bld-q30', 'What index does the FIRST item in an array have?', '["1","0","-1","First"]', 1, 'Arrays start counting at 0 (zero-indexed). The first item is index 0, the second is index 1, and so on.', 2),
  ('bld-q30', 'How do you get the second item from: const colors = ["red","green","blue"]?', '["colors[1]","colors[2]","colors(2)","colors.2"]', 0, 'Square bracket notation with the index gets array items. The second item is at index 1: colors[1] = "green".', 3),
  ('bld-q30', 'Which method adds an item to the END of an array?', '["push()","add()","append()","insert()"]', 0, 'array.push(newItem) adds an item to the end of the array and returns the new length.', 4),
  ('bld-q30', 'Which method removes and returns the LAST item of an array?', '["shift()","delete()","pop()","remove()"]', 2, 'array.pop() removes the last item from the array and returns it.', 5),
  ('bld-q30', 'What does array.length return?', '["The last item","The index of the last item","The total number of items","The first item"]', 2, 'array.length gives you the total number of items in the array. For ["a","b","c"], length is 3.', 6),
  ('bld-q30', 'Which method checks if an item exists in an array?', '["array.has()","array.contains()","array.includes()","array.find()"]', 2, 'array.includes(value) returns true if the value is in the array, false if it is not.', 7),
  ('bld-q30', 'What does array.forEach() do?', '["Creates a new array","Returns a single value","Runs a function for each item in the array","Removes duplicates"]', 2, 'forEach() calls a function once for every item in the array. Use it when you want to do something with each item.', 8),
  ('bld-q30', 'What does array.filter() return?', '["The first matching item","A new array with only items that pass the test","True or false","The number of matching items"]', 1, 'filter() creates a NEW array containing only the items for which the callback function returns true.', 9),
  ('bld-q30', 'What does array.map() do?', '["Removes items","Finds an item","Creates a new array by transforming each item","Sorts the array"]', 2, 'map() creates a NEW array where every item has been transformed by your callback function.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q31: JavaScript Objects Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q31', 'What is a JavaScript object?', '["A list of items","A collection of key-value pairs inside { }","A type of loop","A function with no return"]', 1, 'An object stores related data as key-value pairs: const person = { name: "Alex", age: 12 };', 1),
  ('bld-q31', 'How do you access the name property of: const cat = { name: "Whiskers", age: 3 }?', '["cat[name]","cat->name","cat.name","cat(name)"]', 2, 'Dot notation accesses object properties: cat.name returns "Whiskers". You can also use cat["name"].', 2),
  ('bld-q31', 'What are the keys in { color: "red", size: 12 }?', '["red and 12","color and size","{ } and :","object and value"]', 1, 'Keys (also called property names) are on the left of the colon: color and size. The values are red and 12.', 3),
  ('bld-q31', 'How do you add a new property to an existing object?', '["object.newProp == value","object.newProp = value","object.add(newProp, value)","object[add] = value"]', 1, 'You can add properties with dot notation: person.email = "test@example.com"; This creates it if it does not exist.', 4),
  ('bld-q31', 'Can an object property hold an array?', '["No, only numbers","No, only strings","Yes, any value including arrays and other objects","Yes, but only numbers in the array"]', 2, 'Object values can be any type: numbers, strings, booleans, arrays, functions, or other objects.', 5),
  ('bld-q31', 'What does Object.keys(obj) return?', '["The object''s values","An array of the object''s property names","The number of properties","The first property"]', 1, 'Object.keys() returns an array of all the property names (keys) in the object.', 6),
  ('bld-q31', 'What is a method in an object?', '["A property that holds a string","A property that holds a function","The object''s name","An array inside an object"]', 1, 'A method is a function stored as a property of an object: person.greet = function() { return "Hello!"; }', 7),
  ('bld-q31', 'How do you loop over all properties in an object?', '["for...of loop","for...in loop","while loop","forEach loop"]', 1, 'for...in loops over all enumerable property keys of an object: for (const key in person) { console.log(key); }', 8),
  ('bld-q31', 'What does this create? const point = { x: 10, y: 20 };', '["An array with two items","An object with properties x=10 and y=20","A function with two parameters","Two separate variables"]', 1, 'This creates an object called point with two properties: point.x is 10 and point.y is 20.', 9),
  ('bld-q31', 'What is the difference between an object and an array?', '["No difference","Arrays use numbers as keys, objects use named keys","Objects are faster","Arrays can only hold strings"]', 1, 'Arrays use numeric indexes (0, 1, 2...) for ordered lists. Objects use named keys for describing a thing''s properties.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q32: JavaScript DOM Basics Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q32', 'What does DOM stand for?', '["Document Object Model","Document Order Manager","Data Object Method","Design Object Map"]', 0, 'DOM = Document Object Model. It is the browser''s way of representing your HTML as a tree of objects that JavaScript can read and change.', 1),
  ('bld-q32', 'Which method selects an element by its id?', '["document.getElement(id)","document.getElementById(id)","document.selectId(id)","document.findById(id)"]', 1, 'document.getElementById("myId") finds the element with that exact id attribute and returns it.', 2),
  ('bld-q32', 'Which method selects the FIRST element matching a CSS selector?', '["document.find()","document.getElement()","document.querySelector()","document.select()"]', 2, 'document.querySelector(".myClass") or document.querySelector("#myId") returns the first matching element.', 3),
  ('bld-q32', 'Which property changes the text content of an element safely?', '["element.html","element.innerHTML","element.textContent","element.text"]', 2, 'textContent sets or gets the plain text of an element — it treats everything as text, which is safer than innerHTML.', 4),
  ('bld-q32', 'How do you change the background colour of an element with JavaScript?', '["element.background = ''blue''","element.style.backgroundColor = ''blue''","element.css(''background'', ''blue'')","element.color.background = ''blue''"]', 1, 'element.style.propertyName accesses inline styles. CSS property names become camelCase: background-color → backgroundColor.', 5),
  ('bld-q32', 'What does document.createElement("div") do?', '["Selects an existing div","Creates a new div element in memory","Deletes a div","Finds all divs"]', 1, 'createElement() creates a new HTML element in memory. You then need to append it to the page with appendChild() or similar.', 6),
  ('bld-q32', 'What does element.appendChild(child) do?', '["Removes the child element","Replaces the element","Adds child as the last item inside element","Adds child before element"]', 2, 'appendChild() inserts a child element as the last child inside the parent element.', 7),
  ('bld-q32', 'How do you add a CSS class to an element using JavaScript?', '["element.class = ''active''","element.classList.add(''active'')","element.style.class = ''active''","element.addclass(''active'')"]', 1, 'element.classList.add("className") adds a class. classList also has .remove(), .toggle(), and .contains() methods.', 8),
  ('bld-q32', 'What does querySelectorAll() return?', '["The first matching element","All matching elements as a NodeList","True or false","The number of matching elements"]', 1, 'querySelectorAll() returns a NodeList (list) of ALL elements matching the selector, not just the first one.', 9),
  ('bld-q32', 'How do you remove an element from the page?', '["element.delete()","element.hide()","element.remove()","element.destroy()"]', 2, 'element.remove() removes the element from the DOM completely. It is clean and direct.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q33: JavaScript Events Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q33', 'What is a JavaScript event?', '["A type of variable","Something that happens in the browser, like a click","A function with no parameters","A CSS animation"]', 1, 'An event is something that happens — a mouse click, a key press, a page load, a form submit. JavaScript can listen and respond to events.', 1),
  ('bld-q33', 'Which method attaches an event listener to an element?', '["element.on()","element.listen()","element.addEventListener()","element.event()"]', 2, 'addEventListener() is the standard way to attach event handlers: element.addEventListener("click", myFunction);', 2),
  ('bld-q33', 'Which event fires when a user clicks an element?', '["press","tap","click","select"]', 2, 'The "click" event fires when a user clicks (or taps on mobile) an element.', 3),
  ('bld-q33', 'What is the "event object" passed to an event handler?', '["The element that was clicked","An object with information about the event (what key was pressed, where the click was, etc.)","The function itself","The HTML of the page"]', 1, 'The event object is automatically passed to your handler function. It contains details like event.target (what was clicked) and event.key.', 4),
  ('bld-q33', 'What does event.preventDefault() do?', '["Removes the event listener","Stops the event from bubbling","Stops the browser''s default behaviour (like following a link or submitting a form)","Pauses all events"]', 2, 'preventDefault() stops the browser doing what it normally would — e.g., stops a form from reloading the page when submitted.', 5),
  ('bld-q33', 'Which event fires when the user types in an input field?', '["type","keypress","input","change"]', 2, 'The "input" event fires every time the value of an input changes — immediately as the user types.', 6),
  ('bld-q33', 'What does event.target refer to?', '["The event type","The element that triggered the event","The parent element","The document"]', 1, 'event.target is the specific element that the user interacted with — for example, the exact button that was clicked.', 7),
  ('bld-q33', 'Which event fires when a key is pressed down?', '["keyup","keypress","keypush","keydown"]', 3, 'keydown fires the moment a key is pressed. keyup fires when the key is released.', 8),
  ('bld-q33', 'What is event bubbling?', '["An event that repeats forever","An error in event handling","An event that travels up from the target to its parent elements","Events that only work with forms"]', 2, 'When an event fires on an element, it then bubbles up to parent elements. A click on a button also triggers click on its parent div, etc.', 9),
  ('bld-q33', 'Which event fires when the page and all its resources have fully loaded?', '["DOMContentLoaded","ready","pageload","load"]', 3, 'The "load" event on window fires when everything (images, scripts, styles) has finished loading. DOMContentLoaded fires when just the HTML is ready.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q34: JavaScript Strings Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q34', 'How many characters are in the string "Hello"?', '["4","6","5","7"]', 2, '"Hello" has 5 characters: H, e, l, l, o. Use "Hello".length to check — it returns 5.', 1),
  ('bld-q34', 'Which character is at index 0 in "banana"?', '["n","a","b","an"]', 2, 'Strings are indexed like arrays, starting at 0. "banana"[0] = "b".', 2),
  ('bld-q34', 'What does "hello".toUpperCase() return?', '["Hello","HELLO","hello","HeLLo"]', 1, 'toUpperCase() converts every character to uppercase. "hello".toUpperCase() = "HELLO".', 3),
  ('bld-q34', 'What does string.trim() do?', '["Cuts the string in half","Removes spaces from the start and end","Removes all spaces everywhere","Makes the string shorter"]', 1, 'trim() removes whitespace (spaces, tabs) from both ends of a string. "  hello  ".trim() = "hello".', 4),
  ('bld-q34', 'What does "hello world".includes("world") return?', '["world","hello","false","true"]', 3, 'includes() returns true if the substring is found anywhere in the string, false if not.', 5),
  ('bld-q34', 'What is a template literal?', '["A string in single quotes","A string using backticks that can embed variables with ${}","A string that is a template for HTML","A very long string"]', 1, 'Template literals use backticks ` ` and allow you to embed variables: `Hello, ${name}!` is easier than "Hello, " + name + "!"', 6),
  ('bld-q34', 'What does "cat,dog,fish".split(",") return?', '["cat dog fish","[''cat'',''dog'',''fish'']","cat","catdogfish"]', 1, 'split() breaks a string into an array at the separator. "cat,dog,fish".split(",") = ["cat","dog","fish"].', 7),
  ('bld-q34', 'Which method finds the position of a substring?', '["string.find()","string.search()","string.indexOf()","string.position()"]', 2, 'indexOf() returns the index of the first occurrence of a substring, or -1 if not found.', 8),
  ('bld-q34', 'What does "Hello World".slice(6) return?', '["Hello","Hello World","World","ello"]', 2, 'slice(startIndex) extracts from that index to the end. Index 6 is "W", so you get "World".', 9),
  ('bld-q34', 'What does string.replace("old", "new") do?', '["Replaces every occurrence of old","Replaces the first occurrence of old with new","Removes old from the string","Checks if old is in the string"]', 1, 'replace() replaces only the FIRST match. To replace all occurrences, use replaceAll() or a regex with the g flag.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q35: CSS Flexbox Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q35', 'Which CSS property activates Flexbox on a container?', '["flex: on","layout: flex","display: flex","flexbox: true"]', 2, 'Adding display: flex to a container turns on Flexbox. Its direct children automatically become flex items.', 1),
  ('bld-q35', 'What is the default direction flex items are arranged?', '["column (top to bottom)","row (left to right)","diagonal","random"]', 1, 'The default flex-direction is row, which arranges items horizontally from left to right.', 2),
  ('bld-q35', 'Which property controls horizontal alignment in a row-direction flex container?', '["align-items","justify-self","justify-content","flex-align"]', 2, 'justify-content aligns items along the main axis. In a row container, that is horizontal (left to right).', 3),
  ('bld-q35', 'Which value of justify-content puts equal space BETWEEN items (not at the edges)?', '["space-around","space-evenly","center","space-between"]', 3, 'space-between puts gaps between items but not at the outer edges. space-around adds space around each item including the edges.', 4),
  ('bld-q35', 'Which property aligns items vertically in a row-direction flex container?', '["justify-content","vertical-align","align-items","flex-vertical"]', 2, 'align-items controls alignment on the cross axis. In a row flex container, that means vertical alignment.', 5),
  ('bld-q35', 'How do you centre an element both horizontally and vertically with flexbox?', '["justify-content: middle; align-items: middle","justify-content: center; align-items: center","center: both","flex: center"]', 1, 'Using both justify-content: center AND align-items: center on a flex container centres children in both directions.', 6),
  ('bld-q35', 'What does flex-wrap: wrap do?', '["Makes text wrap inside items","Allows flex items to move to the next row if they don''t fit","Wraps the container in a border","Makes items shrink to fit"]', 1, 'flex-wrap: wrap allows flex items to break onto a new line if they run out of space, instead of overflowing.', 7),
  ('bld-q35', 'What does flex-grow: 1 do to a flex item?', '["Stops the item from growing","Doubles the item''s size","Makes the item grow to fill available space","Sets the item''s width to 1px"]', 2, 'flex-grow: 1 allows the item to grow and take up remaining space. All items with flex-grow: 1 share space equally.', 8),
  ('bld-q35', 'Which property adds space between flex items without using margin?', '["spacing","padding","gap","flex-space"]', 2, 'The gap property on the flex container adds consistent space between all flex items cleanly.', 9),
  ('bld-q35', 'What does flex-direction: column do?', '["Arranges items right to left","Arranges items in a vertical column (top to bottom)","Makes all items the same width","Removes flex layout"]', 1, 'flex-direction: column stacks flex items vertically. The main axis becomes vertical and the cross axis becomes horizontal.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;

-- =============================================================================
-- Q36: CSS Animations Quiz
-- =============================================================================
INSERT INTO quiz_questions (quiz_id, question, options, correct_answer, explanation, points, sort_order)
SELECT q.id, qq.question, qq.options::jsonb, qq.correct_answer, qq.explanation, 10, qq.sort_order
FROM quizzes q, (VALUES
  ('bld-q36', 'Which CSS property creates a smooth change when an element''s style changes?', '["animation","transform","transition","change"]', 2, 'transition smoothly animates a CSS property when it changes — for example, colour changing on hover.', 1),
  ('bld-q36', 'What does @keyframes define?', '["A CSS selector","A font","The steps of a CSS animation","A media query"]', 2, '@keyframes defines the stages (steps) of an animation — what the element looks like at different points in time.', 2),
  ('bld-q36', 'Which CSS property applies a @keyframes animation to an element?', '["transition","animation-name","animate","keyframe"]', 1, 'animation-name connects an element to a @keyframes rule. You also need animation-duration for it to run.', 3),
  ('bld-q36', 'What does animation-duration: 2s mean?', '["The animation delays 2 seconds","The animation repeats 2 times","The animation takes 2 seconds to complete one cycle","The animation runs at 2 frames per second"]', 2, 'animation-duration sets how long one full cycle of the animation takes. 2s = 2 seconds.', 4),
  ('bld-q36', 'Which value makes an animation loop forever?', '["animation-repeat: forever","animation-count: always","animation-iteration-count: infinite","animation-loop: true"]', 2, 'animation-iteration-count: infinite makes the animation repeat forever without stopping.', 5),
  ('bld-q36', 'What does "from" and "to" represent inside @keyframes?', '["From one element to another","The start state and end state of the animation","The minimum and maximum size","The first and last element"]', 1, '"from" is 0% (start) and "to" is 100% (end) of the animation. You can also use percentage values for more steps.', 6),
  ('bld-q36', 'Which CSS property moves an element without affecting the layout?', '["margin","position","transform","display"]', 2, 'transform (with translateX, translateY, scale, rotate) moves or resizes elements without disrupting page layout.', 7),
  ('bld-q36', 'What does transition-timing-function: ease do?', '["Makes the animation linear","Makes the animation slow at start and end, fast in the middle","Stops the animation","Makes it bounce"]', 1, 'ease starts slow, speeds up, then slows down at the end. It feels natural for most interface animations.', 8),
  ('bld-q36', 'What does animation-fill-mode: forwards do?', '["The animation plays forward only","The element keeps the final animation state after it ends","The animation loops forward","The element returns to its original state"]', 1, 'forwards keeps the element in its final animation state instead of snapping back to the original after finishing.', 9),
  ('bld-q36', 'Which two CSS properties are best to animate for smooth performance?', '["width and height","margin and padding","opacity and transform","color and font-size"]', 2, 'opacity and transform are GPU-accelerated and produce smooth 60fps animations. Animating layout properties like width causes slower repaints.', 10)
) AS qq(quiz_slug, question, options, correct_answer, explanation, sort_order)
WHERE q.slug = qq.quiz_slug
ON CONFLICT DO NOTHING;
