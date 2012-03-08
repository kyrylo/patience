Patience
========

* [https://github.com/kyrylo/patience/](https://github.com/kyrylo/patience/ "Home page")

Description
-----------

![Patience, version 0.1.0](http://img-fotki.yandex.ru/get/5908/98991937.6/0_7259e_d9e01c58_orig "Patience, version 0.1.0")

_Patience_ is a card game (also known as Solitaire), which is written in Ruby.
The game is based on Ray, a Ruby library for games. Currenlty, _Patience_ runs
_only_ on GNU/Linux, although, I'm planning to support it on Windows.

How to play
-----------

The play area of _Patience_ (Solitaire) consits of four zones: Waste, Tableau,
Stock and Foundation. The goal of the game is to allocate all the cards from
Tableau to Foundation. You can drag cards from pile to pile with your mouse.
Remember, you can't drop cards anywhere: there are some rules, restricting that
mess. Brief rules:

![Patience, rules](http://img-fotki.yandex.ru/get/6101/98991937.7/0_726e0_789437d8_orig "Patience, rules")

### Stock

* In the very beginning of each game comprises of 24 cards
* A click on Stock reveals its card and moves it to Waste
* You can't drag cards from Stock
* You can't drop cards onto Stock
* If Stock is empty, you can refresh it with cards from Waste (if there are any)
  by clicking it again.

### Waste

* In the very beginning of each game has no cards
* You can drag cards from Waste and drop them onto Tableau
* You can't drop cards onto Waste

### Tableau

* Accepts cards from Waste and other piles from Tableau
* You can drop _only_ a King onto the freed pile
* You can drop a card onto a card in the pile, which's lower by one rank and has
  suit of different color.
  Example:

  ![Correct drop](http://img-fotki.yandex.ru/get/6200/98991937.7/0_726e1_bc6edf54_orig "Correct drop") ![Wrong drop](http://img-fotki.yandex.ru/get/6200/98991937.7/0_726e3_640d9de0_orig "Wrong drop")

* You can move whole (valid) piles onto a proper cards

### Foundation

* In the very beginning of each game has no cards
* If the pile of Foundation is empty, it can accept only an Ace.
* If the pile of Foundation isn't empty, it will accept only cards of the same
  suit, that are higher by one rank.

### Winning conditions

* All the cards are in Foundation, other zones has no cards.

Requirements
------------

### Runs on

* GNU/Linux

### Dependencies

* [Ruby](http://ruby-lang.org/ "Ruby")
  (Tested _only_ on 1.9.3 version)

* [Ray](https://github.com/Mon-Ouie/ray/ "Ray") (0.2.0)

Installation
------------

### Regular GNU/Linux way

        gem install patience

To launch the game:

        % patience

### Irregular way

        git clone git://github.com/kyrylo/patience.git patience

To launch the game:

        % cd patience
        % ruby bin/patience

Credits
-------

* Thanks to [Bil Bas (Spooner)](https://github.com/Spooner/ "Bil Bas (Spooner)") for giving advices and answering my questions
* Thanks to [Mon Ouïe](https://github.com/Mon-Ouie "Mon Ouïe") for Ray

Future plans
------------

The vector of progress sits in TODO.md file.

License
-------

The project uses Zlib License. See LICENSE file for more information.
