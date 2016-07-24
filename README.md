# Connect Four Microservice

Acts as a simple base for establishing a connect-four game, exposed via a REST API

The connect four game is primarily represented as a matrix of 0's, 1's, and 2's. 
0's are empty spaces, while 1's and 2's are the two players competing against one another.

_Example Board_

```ruby
 
 | 0  0  0  0  0  0 |

 | 1  0  0  0  0  0 |
 
 | 1  1  0  0  0  0 |
 
 | 2  1  1  0  0  0 |
 
 | 1  1  2  1  0  0 |
 ```
 ___
 Currently the REST API takes two `GET` Requests- 
 
 `GET /api/setup?size=` where size is the board size (smaller dimension)
 
 `GET /api/play?col=&player=` where col is the column you are adding a piece and player is which player is adding the piece
