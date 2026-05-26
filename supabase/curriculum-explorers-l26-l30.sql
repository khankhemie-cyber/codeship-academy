-- =============================================================================
-- CODEship Academy — Explorers Level Lessons (exp-l26 to exp-l30)
-- 5 lessons: Scratch-based, Ages 5-8, Beginner
-- Run after schema.sql and curriculum.sql
-- =============================================================================

INSERT INTO public.lessons (slug, title, level, category, language, difficulty, duration_minutes, xp_reward, sort_order, instructions) VALUES

('exp-l26', 'What Is Scratch? Your Coding Playground!', 'explorers', 'Scratch', 'en', 'beginner', 20, 100, 26,
'## What Is Scratch? Your Coding Playground! 🎉

Welcome to Scratch — the most exciting coding adventure for young coders! Scratch is a free website where you can make your own games, stories, and animations just by snapping colourful blocks together. No typing complicated code — just drag, drop, and create!

### What Is Scratch? 🐱

Scratch was made by some very clever people at MIT (a famous university in the USA). They wanted children just like you to be able to make real programmes without needing to know difficult words. Millions of kids around the world use Scratch every day. You are joining a huge, friendly coding community!

You can find Scratch at **scratch.mit.edu** — ask a grown-up to help you get there.

### The Three Main Parts of Scratch 🖥️

When you open a Scratch project, you will see three important areas:

**1. The Stage 🎭**
The Stage is the big white area on the right side of the screen. This is where your project comes to life! Whatever your character does, you will see it happen right here. Think of it like the stage in a school play — it is where the action happens!

**2. Sprites 🐾**
A Sprite is a character or object in your project. The default sprite is a friendly orange cat. You can have lots of different sprites — a dog, a butterfly, a spaceship, or even your own drawing! Each sprite can move, talk, and do all sorts of things.

**3. Blocks 🧩**
Blocks are the colourful pieces you use to give instructions. They are sorted into groups by colour:
- 🔵 **Blue blocks** — make things move (Motion)
- 🟣 **Purple blocks** — make things look different (Looks)
- 🟡 **Yellow blocks** — make sounds (Sound)
- 🟠 **Orange blocks** — control when things happen (Control)
- 🟢 **Green blocks** — check if things are true or false (Sensing)

### How Do You Use Blocks? 🧠

Blocks snap together like LEGO! You pick up a block from the left side and drag it into the middle area called the **Scripts area**. When you click the green flag at the top of the Stage, your blocks run and your sprite comes to life!

Here is what a simple Scratch programme looks like:

```
When 🚩 clicked
  say "Hello! I am a Scratch cat!" for 2 seconds
  move 10 steps
  say "Wheee! I am moving!" for 2 seconds
```

See how the blocks tell your sprite exactly what to do and when to do it? That is coding!

### The Scratch Toolbox 🛠️

On the left side of the screen, you will see all the blocks organised into groups. Click on a group name like "Motion" and all the motion blocks appear. You can drag any block you like into the middle. Easy!

You can also:
- **Add new sprites** by clicking the cat icon at the bottom
- **Change the background** (called a backdrop) by clicking the landscape icon
- **Draw your own sprite** using the paint editor

### Activity: Explore Scratch! 🔍

Today your mission is to simply explore Scratch and get to know where everything is. Follow these steps:

1. Open Scratch (scratch.mit.edu) or your school''s Scratch-like app
2. Click on the orange cat sprite and say hello! 😄
3. Find the blue "Motion" blocks and drag "move 10 steps" into the Scripts area
4. Click the block once — did the cat move? 🐱
5. Try dragging a purple "Looks" block called "say hello for 2 seconds" — click it and watch!
6. Press the green flag 🚩 and then press the red stop button ⏹️

You are already coding! How brilliant is that?

### Fun Fact 🚀

Scratch is used by over **100 million people** around the world! Kids in more than 150 countries have made projects in Scratch. The projects made in Scratch every day number in the hundreds of thousands. You are now part of this amazing global community!

### What Did You Learn? 🌟
- Scratch is a free coding website where you snap blocks together
- The Stage is where your project runs and you see everything happen
- Sprites are the characters in your project
- Blocks are colour-coded instructions that tell sprites what to do
- You can explore and create just by dragging and clicking — no hard typing needed!'),

('exp-l27', 'Making Your Sprite Move', 'explorers', 'Scratch', 'en', 'beginner', 20, 100, 27,
'## Making Your Sprite Move 🏃

One of the most exciting things in Scratch is making your sprite zoom around the screen! Today you will learn all about Motion blocks — the blue blocks that make your characters come alive!

### The Motion Blocks Family 🔵

Click on the blue "Motion" section on the left side of Scratch. You will see lots of blue blocks. Do not be scared — you do not need to use all of them today. We will focus on the most important ones!

### Move Steps 👟

The very first block you will learn is:

```
move (10) steps
```

This moves your sprite forward by 10 steps. The bigger the number, the further it moves! Try these:
- `move 10 steps` — small move
- `move 50 steps` — bigger move
- `move 100 steps` — big jump!

A "step" in Scratch is a tiny distance on the screen. The stage is 480 steps wide and 360 steps tall.

### Turning Your Sprite 🔄

Your sprite can also spin! Use these blocks:

```
turn ↻ (15) degrees
turn ↺ (15) degrees
```

The ↻ symbol means turn clockwise (to the right, like a clock). The ↺ symbol means turn anti-clockwise (to the left).

Degrees are how we measure turning:
- **90 degrees** = a quarter turn (like a right-angle corner)
- **180 degrees** = a half turn (you are facing the opposite way!)
- **360 degrees** = a full spin (you end up facing the same way you started)

### Go To a Position 📍

You can also teleport your sprite to any spot on the stage! Every spot on the stage has an address made of two numbers:
- **X** tells you how far left or right (0 is the middle)
- **Y** tells you how far up or down (0 is the middle)

```
go to x: (0) y: (0)
```

This sends your sprite right to the centre of the stage! Try different numbers:
- `go to x: (100) y: (0)` — right side of the stage
- `go to x: (-100) y: (0)` — left side of the stage
- `go to x: (0) y: (100)` — top of the stage

### Glide Smoothly 🌊

Instead of teleporting, you can make your sprite glide gracefully to a new spot:

```
glide (1) secs to x: (100) y: (50)
```

This makes the sprite slide smoothly to position (100, 50) in 1 second. Try changing the number of seconds to make it faster or slower!

### Putting It All Together 🎬

Here is a fun script that makes your sprite do a little dance:

```
When 🚩 clicked
  go to x: (0) y: (0)
  move 50 steps
  turn ↻ 90 degrees
  move 50 steps
  turn ↻ 90 degrees
  move 50 steps
  turn ↻ 90 degrees
  move 50 steps
```

Can you guess what shape that makes? Try it and find out! 🔲

### Activity: Design a Movement Routine! 🕺

Create your own sprite movement routine. Try to make your sprite:

1. Start in the middle of the stage (`go to x: 0 y: 0`)
2. Move to the right
3. Turn around
4. Move back to the middle
5. Do a spin (turn 360 degrees)
6. Say something fun at the end!

**Bonus challenge:** Can you make your sprite draw a triangle? Hint: a triangle has 3 sides and each corner turns 120 degrees!

### Fun Fact 🚀

The x and y coordinates that Scratch uses are the same kind of coordinates that mathematicians use! When you grow up and study graphs at school, you will already know exactly what x and y mean. Coding teaches you maths without you even noticing! 🧮

### What Did You Learn?
- The blue Motion blocks make sprites move around the stage
- "Move steps" pushes your sprite forward — bigger numbers = more movement
- Turning uses degrees: 90 = quarter turn, 360 = full spin
- x and y coordinates are your sprite''s address on the stage
- "Glide" moves your sprite smoothly to a new position
- You can chain blocks together to create movement routines!'),

('exp-l28', 'Sounds and Speech in Scratch', 'explorers', 'Scratch', 'en', 'beginner', 20, 100, 28,
'## Sounds and Speech in Scratch 🎵

Did you know your Scratch sprites can talk AND sing? Today we are going to bring your project to life with sounds and speech bubbles! Get ready to make some noise! 🎤

### Making Your Sprite Speak 💬

In Scratch, sprites can show speech bubbles — just like in comic books! Find the purple "Looks" section and look for these two blocks:

```
say [Hello!] for (2) seconds
```

This makes a speech bubble appear above your sprite for 2 seconds, then it disappears. You can change "Hello!" to anything you like!

```
say [Hello!]
```

This one makes the speech bubble stay there forever (until another block changes it).

### Thinking Bubbles 💭

Sprites can also show thought bubbles — like when you are daydreaming!

```
think [Hmm...] for (2) seconds
think [I wonder what''s for lunch?]
```

The thought bubble looks different from the speech bubble — it has little circles instead of a pointed tail. Very cute!

### Playing Sounds 🔊

Now for the really exciting part — actual sounds! Click on the yellow "Sound" section. You will see blocks like this:

```
play sound [Meow] until done
start sound [Meow]
```

**"Play sound until done"** plays the sound and waits for it to finish before doing the next block.
**"Start sound"** plays the sound and immediately moves on to the next block — great for background music!

### Adding New Sounds 🎶

Scratch comes with lots of built-in sounds you can use. Here is how to add a new sound to your sprite:

1. Click on your sprite to select it
2. Click the **"Sounds"** tab at the top (next to "Code" and "Costumes")
3. Click the speaker icon at the bottom left to add a sound
4. You can choose from Scratch''s library, record your own voice, or upload a sound!

You can also record your own voice! Click the microphone icon and say something — then you can play your own voice in your project. How cool is that?

### Changing the Volume 🔈

You can make sounds louder or quieter:

```
set volume to (100) %
change volume by (-10)
```

100% is full volume. 0% is completely silent. You can even make sounds get quieter gradually by changing the volume little by little!

### Putting Sound and Speech Together 🎭

Here is a fun script that combines speech and sound:

```
When 🚩 clicked
  play sound [Meow] until done
  say [Hi! My name is Whiskers!] for 3 seconds
  play sound [Meow] until done
  think [I wonder if there''s any fish...] for 2 seconds
  play sound [Meow] until done
  say [Bye!] for 2 seconds
```

### Activity: Make a Talking Story! 📖

Create a short story with your sprite that uses both speech AND sound. Here are some ideas:

**Option 1 — The Brave Cat:**
- Cat says "I am going on an adventure!"
- Play a dramatic sound
- Cat moves to the right
- Cat says "I made it!"

**Option 2 — The Funny Robot:**
- Robot says "BEEP BOOP. Greetings, human."
- Play a robot sound
- Robot thinks "I secretly love pizza..."
- Robot says "BEEP BOOP. Goodbye!"

**Option 3 — Make your own story!**
- Use at least 3 say or think blocks
- Use at least 2 different sounds
- Make your sprite move between speech bubbles

### Fun Fact 🚀

The sound effects in Scratch were recorded by real people in a sound studio! Professional sound designers recorded every meow, pop, boing, and crash. That''s the same job that people do for cartoons and video games. Maybe one day YOU could be a sound designer! 🎧

### What Did You Learn?
- The "say" block creates speech bubbles for your sprite
- The "think" block creates thought bubbles — great for showing inner thoughts!
- You can play sounds from Scratch''s library or even record your own voice
- "Play sound until done" waits before continuing; "start sound" keeps going immediately
- Volume can be controlled with blocks — from silent (0%) to full blast (100%)
- Combining movement, speech, and sound makes your project feel alive and fun!'),

('exp-l29', 'Loops: Do It Again and Again!', 'explorers', 'Scratch', 'en', 'beginner', 20, 100, 29,
'## Loops: Do It Again and Again! 🔁

Imagine if you had to write the same instruction 100 times. That would take forever! Luckily, programmers invented something called a **loop** — a magical shortcut that tells the computer to do something over and over again. Today you will learn about loops in Scratch!

### What Is a Loop? 🤔

A loop is an instruction that says "do this thing MORE than once." Instead of writing the same blocks over and over again, you can wrap them inside a loop block and the computer will repeat them automatically!

Think of your favourite song — it has a chorus that repeats. That chorus is like a loop! 🎵

### The Repeat Block 🔢

The first loop block in Scratch looks like this:

```
repeat (10)
  [blocks go inside here]
```

The number inside tells Scratch how many times to repeat everything inside the loop. Let''s see the difference this makes:

**Without a loop (boring and long!):**
```
move 10 steps
move 10 steps
move 10 steps
move 10 steps
move 10 steps
```

**With a loop (smart and short!):**
```
repeat (5)
  move 10 steps
```

Both do exactly the same thing — but the loop version is so much easier to write! 🎉

### Try This: Drawing a Square 🔲

Here is a great example of loops making life easier. To draw a square, your sprite needs to:
- Move forward
- Turn right
- Do that 4 times (once for each side!)

**Without a loop:**
```
move 100 steps
turn ↻ 90 degrees
move 100 steps
turn ↻ 90 degrees
move 100 steps
turn ↻ 90 degrees
move 100 steps
turn ↻ 90 degrees
```

**With a loop:**
```
repeat (4)
  move 100 steps
  turn ↻ 90 degrees
```

The loop version does exactly the same thing with half the blocks! Clever, right?

### The Forever Block ♾️

The second loop is even more powerful — it runs forever and never stops!

```
forever
  [blocks go inside here]
```

This keeps repeating until you press the red stop button. This is brilliant for things that should always keep happening, like:
- A character that is always bouncing around the screen
- Background music that keeps playing
- A timer that keeps counting

Here is an example — a sprite that bounces back and forth forever:

```
When 🚩 clicked
  forever
    move 5 steps
    if on edge, bounce
```

The "if on edge, bounce" block (in Motion) makes your sprite turn around when it hits the edge of the stage. Combined with the forever loop, your sprite will bounce back and forth endlessly!

### Loops Inside Loops 🌀

You can even put loops inside other loops! This is called a **nested loop**:

```
repeat (3)
  repeat (4)
    move 20 steps
    turn ↻ 90 degrees
  wait 0.5 seconds
  go to x: (0) y: (0)
```

This draws 3 squares, one after another. Wow!

### Activity: Loop Art! 🎨

Let''s make some incredible art using loops! Here is a challenge:

**Step 1:** Set up your pen (ask your teacher to help with the Pen extension if needed, or just watch the sprite move):
```
When 🚩 clicked
  go to x: (0) y: (0)
  point in direction (90)
```

**Step 2:** Try this loop and see what shape appears:
```
repeat (36)
  move 100 steps
  turn ↻ 170 degrees
```

**Step 3:** Try changing the numbers — what happens when you change 36 to 20? What about when you change 170 to 90?

**Bonus:** Try using a forever loop to make your sprite spin in circles forever. Then press the green flag and enjoy your spinning sprite! 🌀

### Fun Fact 🚀

The world''s most powerful computers use loops too! When your computer renders a video game, it is running a loop called the "game loop" that runs 60 times every second — drawing everything on screen, checking your controls, and updating the game world. Loops are everywhere in computing! 🎮

### What Did You Learn?
- A loop is a shortcut that makes the computer repeat instructions
- The "repeat" block runs its instructions a specific number of times
- The "forever" block runs its instructions endlessly until you stop it
- Loops make your code shorter and much easier to read and write
- You can put loops inside loops to create complex and beautiful patterns
- Many things in computers — like video games — use loops all the time!'),

('exp-l30', 'Explorers Level Complete — You Did It!', 'explorers', 'Celebration', 'en', 'beginner', 20, 150, 30,
'## Explorers Level Complete — You Did It! 🏆🎉

CONGRATULATIONS, Explorer! You have finished all 30 Explorers lessons! That is an incredible achievement and you should be SO proud of yourself. Take a moment to celebrate — you have earned it! 🥳

### Look How Far You Have Come! 🌟

Do you remember your very first lesson? You learned what a computer is! Back then, coding might have seemed like a strange, mysterious thing. But look at you now — you are a real coder!

Here is everything you learned on your Explorers journey:

### Fundamentals 🖥️
You started by discovering what computers are and how they are hiding all around us — in fridges, traffic lights, and even toys! You learned about:
- How computers think: **Input → Process → Output**
- The history of computers and how they have changed the world
- Binary numbers — the secret 0s and 1s that computers use
- How the internet connects billions of people together

### Algorithms and Problem Solving 🧩
You became a problem-solving superstar! You discovered:
- What an **algorithm** is — a set of step-by-step instructions
- Why **order matters** in coding
- How to spot and create **patterns**
- **Debugging** — finding and fixing mistakes like a detective
- **Decomposition** — breaking big problems into smaller pieces

### Scratch Adventures 🐱
In your last five lessons, you explored the wonderful world of Scratch! You learned:
- How to navigate the Scratch interface — the **Stage**, **Sprites**, and **Blocks**
- How to use **Motion blocks** to make sprites move, turn, and glide
- How to add **speech bubbles** and **sounds** to bring your sprites to life
- How to use **Loops** — repeat and forever — to make your code smart and efficient
- How to combine everything into amazing interactive projects!

### Your Coding Superpowers 💪

You have developed some really important coding skills:
- **Thinking logically** — breaking problems into steps
- **Being creative** — using blocks to express your ideas
- **Debugging** — figuring out why things do not work and fixing them
- **Persisting** — trying again when something does not work first time
- **Having fun** — the most important skill of all!

### What Amazing Things Can You Make? 🚀

Now that you know Scratch, the possibilities are endless! Here are some projects you could try:

**A Story Animator** — Use multiple sprites to act out your favourite story or make up a brand new one!

**A Simple Game** — Make a sprite that the player controls with arrow keys. Add a score that goes up when you collect items!

**An Art Creator** — Use loops and the Pen extension to create beautiful geometric art with just a few blocks.

**A Quiz Show** — Use the "ask" block to create a quiz about your favourite subject. Right answers get a "CORRECT!" speech bubble!

### Messages From Your Fellow Coders 💌

Around the world, millions of young coders just like you have finished their first coding level. They all felt the same mixture of excitement and pride that you are feeling right now.

Every professional coder — every person who works at Google, or Apple, or makes your favourite video games — they all started exactly where you started. They were all beginners once.

The difference? They kept going. And so will you!

### Activity: Make Your Graduation Project! 🎓

To celebrate finishing the Explorers level, make a special graduation project in Scratch. It can be ANYTHING you like — a story, a game, a song, a piece of art.

The only rule is that it must use at least ONE thing from each of these:
- 🔵 A Motion block (make something move)
- 🟣 A Looks block (speech bubble or costume change)
- 🟡 A Sound block (play a sound or say something)
- 🟠 A Loop (repeat or forever)

When you are done, share it with a friend, a family member, or your teacher. Show them what you have built. You deserve to show off — you are a coder! 🌟

### What Comes Next? 🔭

You have completed the Explorers level — but your coding adventure is just getting started! In the next level, you will take on bigger challenges, learn new coding tools, and create even more amazing things.

The world needs brilliant, creative coders like you. Keep exploring. Keep creating. Keep coding.

You are amazing. 🚀

### What Did You Learn?
- You completed 30 full lessons — that takes real dedication and hard work!
- You understand the fundamentals: what computers are and how they think
- You can write algorithms and solve problems step by step
- You can use Scratch to make sprites move, talk, make sounds, and loop actions
- You are officially a CODEship Academy Explorer graduate!
- The next level awaits — and you are more than ready for it!')

ON CONFLICT (slug) DO UPDATE SET title = EXCLUDED.title, instructions = EXCLUDED.instructions;
