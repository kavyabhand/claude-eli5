# Analogy Bank

Ready-to-use analogies for common technical concepts. Adapt freely — the goal is the idea,
not the exact wording. When the level changes, adjust the analogy's vocabulary, not its structure.

---

## Web & APIs

**API**
A waiter who takes your order to the kitchen and brings the food back. You never go into
the kitchen yourself — you just tell the waiter what you want.

**REST API**
Like ordering pizza by phone. You say what you want (the request), they make it, you get it
(the response). Same menu every time. Same phone number. Very predictable.

**WebSocket**
A phone call — the line stays open and both sides can talk any time.
(vs. HTTP which is like texting: you send, you wait, they reply, the conversation ends.)

**HTTP vs HTTPS**
HTTP is sending a postcard — anyone who handles it can read it.
HTTPS is sending a sealed letter — only the person you're writing to can open it.

**DNS**
A phone book that turns names (like "google.com") into phone numbers (like an IP address).
Your computer looks up the name to find out where to actually call.

**IP address**
Your home address on the internet. Just like a letter needs your street address to reach you,
data needs your IP address to reach your computer.

**CDN (Content Delivery Network)**
Instead of one bakery that serves the whole country, a CDN is a chain of bakeries —
one near you, one near everyone. You always get your bread from the closest one,
so it arrives faster and still warm.

**Load balancer**
A traffic cop at a busy intersection. When too many cars head to the same lane,
the cop sends some to other lanes so nobody gets stuck.

**Firewall**
A bouncer at the door who checks a list. If your name (or your data's type) is on the
approved list, you get in. If not, you wait outside.

---

## Data & Storage

**Database**
A giant filing cabinet with labeled folders. Each drawer is a table, each folder is a row,
each piece of paper inside is a value.

**SQL query**
Asking the filing cabinet a very specific question: "Find me all the folders from last year
with the word 'invoice' in them and sort them by date."

**Index (database)**
The table of contents in a book. Instead of reading every page to find "chapter 7,"
you look it up in the front and jump straight there. An index does the same for a database.

**Cache**
Keeping your lunch in a lunchbox so you don't have to cook every time you're hungry.
The food is ready immediately because you already made it.

**Memory / RAM**
Your desk. The more desk space you have, the more books, papers, and cups you can have
open and within reach at once. When you stand up and leave, the desk gets cleared.

**Storage / disk (SSD/HDD)**
Your bookshelf. Books stay there even when you're not reading them. The shelf doesn't
get cleared when you leave the room.

**Data compression**
Packing a suitcase efficiently. The same stuff fits, but you fold everything tightly so it
takes less space. When you unpack, everything is back to normal.

---

## Code Concepts

**Function**
A recipe. You give it ingredients (inputs), follow the same steps every time, and always
get the same dish (output). Write the recipe once, use it as many times as you want.

**Variable**
A labeled box. You put something inside it and give it a name. Later, when you say the
name, you get whatever's in the box.

**Loop**
Telling someone: "Keep filling the glass until it's full, then stop." It does the same
thing over and over until a condition is met.

**Conditional (if/else)**
A fork in the road. "If it's raining, take an umbrella. Otherwise, leave it home."
The code picks one path depending on what's true.

**Array**
A row of numbered cubbyholes. Cubbyhole 1 has one thing, cubbyhole 2 has another, and so on.
You grab what you need by saying the number.

**Object**
A LEGO set. It has a shape (its data — color, size) and comes with instructions for things
you can do with it (its methods — build, disassemble, swap pieces).

**Class**
A cookie cutter. The cutter is the class — it defines the shape. Each cookie you press
out is an object — it has that shape but is its own separate thing.

**Inheritance**
A child who gets their parent's eye color (inherited traits) but also has their own
personality (things unique to them). In code, a child class gets everything the parent
class has, plus its own additions.

**Recursion**
A mirror facing another mirror. The reflection shows a reflection of a reflection,
going on and on. A function that calls itself is the same idea.

**Bug**
A typo in a recipe that makes it go wrong. "Add 1 cup of salt" instead of "1 teaspoon" —
the instructions are followed exactly, but the result is terrible.

**Dependency**
Needing eggs to bake a cake. You can't bake without them. If someone used up all the eggs,
your whole cake plan falls apart. Software dependencies are packages your code needs
to run.

---

## Systems & Infrastructure

**Server**
A kitchen in a restaurant that cooks meals for many tables. You (the browser or app)
are a table. You order (send a request), the kitchen makes it, the waiter (the network)
brings it to you.

**Cloud**
Someone else's computer that's always on. Instead of buying your own massive server,
you rent space on a company's computers and they keep them running for you.

**Docker / Container**
A lunchbox that carries everything the food needs: the food, the fork, the napkin,
the sauce. No matter whose table you eat at, everything is already in the box.
The food always tastes the same because it brought its own everything.

**Virtual machine**
A computer inside a computer. Like running a pretend arcade machine inside your laptop.
The pretend machine thinks it's real, but it's actually borrowing your laptop's parts.

**Microservices**
A food court instead of one restaurant that does everything. One stall makes pizza,
one makes sushi, one makes coffee. They each do one thing well, and you walk between them.

**Monolith**
One giant restaurant where the kitchen, the host stand, the bar, and the dining room
are all one connected thing. Fast to build at first, but hard to change one part
without affecting everything else.

---

## Networking & Security

**Encryption**
A secret language only you and your friend know. Even if someone intercepts your
note, all they see is gibberish.

**SSL certificate**
An ID badge from a trusted authority. When a website shows you a padlock, it means
a trusted organization checked and confirmed: "yes, this is actually who they say they are."

**Token (auth token)**
A wristband from a concert. The venue checked your ticket at the door and gave you a
wristband. Now you can walk around and get back in without showing your ticket again.

**Middleware**
The translator standing between two people who speak different languages. The request
comes in on one side, the middleware adjusts it, and passes it on in a form the next
piece can understand.

**Proxy**
A middleman. Instead of going directly to the shop, you tell your assistant what you need.
They go, get it, and bring it back. The shop only ever sees the assistant, not you.

---

## Development Tools

**Git**
A magical notebook that remembers every single version of your essay, forever.
You can go back to any version you ever saved. If you ruin it, yesterday's version
is always there.

**Git branch**
Making a photocopy of your essay to try a risky new idea. If it works, you glue it
into the original. If it doesn't, you throw the copy away and the original is fine.

**Git merge**
Two people worked on different chapters of the same book. Merging is combining those
chapters back into one book. Sometimes a sentence is in both chapters and you have
to pick which one to keep (that's a merge conflict).

**Compiler**
Translating a book from French into English so you can read it. The code you write
is the French — the compiler turns it into something the computer can actually understand.

**Interpreter**
A live translator at a meeting. Instead of translating the whole book in advance,
they translate one sentence at a time as the speaker speaks.

**Version control**
A time machine for your code. You can go forward and back, create alternate timelines
(branches), and merge timelines back together.

---

## Async & Concurrency

**Async / asynchronous**
Sending a letter and then going about your day while you wait for the reply.
You don't stand frozen at the mailbox — you just check it later.

**Sync / synchronous**
Standing at the mailbox waiting for the reply before doing anything else.
Nothing happens until the letter comes back.

**Thread**
Two workers doing different parts of the same job at the same time, in the same office.
They share the same supplies (memory) and have to be careful not to reach for the
same thing at once.

**Deadlock**
Two people each holding something the other one needs, both waiting for the other
to go first. Neither can move. Nothing happens.

**Race condition**
Two kids running to grab the last piece of cake. Whoever gets there first wins —
but the result depends on who runs faster that day, not on any rule. Unpredictable.

---

## Patterns & Architecture

**Design pattern**
A proven building blueprint. If you need to build a certain kind of room, someone has
already figured out the best way to do it. You don't have to invent it from scratch.

**Regex (regular expression)**
A very picky search with exact rules. Like saying "find all words in this book that
start with B, end in -ing, and are exactly 7 letters long." It only counts a word
if it matches every single rule.

**ORM (Object-Relational Mapper)**
A translator between your code and your database. Instead of learning to speak the
database's language (SQL), you speak your own language and the ORM translates for you.

**Webhook**
Instead of calling a restaurant every 5 minutes to ask "is my table ready?",
the restaurant calls YOU when the table is ready. A webhook is that callback.

**Message queue**
A to-do list that workers pull tasks from. The list takes tasks in, workers pick them
off one at a time. If workers are busy, tasks wait in line — nothing gets lost.
