---
title: 蒙特卡洛树搜索MCTS实现五子棋
date: 2022-10-10 16:48:54
categories: 博弈
tags: [算法,博弈]
auther: philxling
top: 1
---

# 蒙特卡洛树

### 简介

1 蒙特卡洛树搜索是一类树搜索算法的统称,称为MCTS,是一种启发式搜索算法,在搜索空间极大的游戏中比较有效,它的目标是给定一个游戏状态,选择最佳的一步,如Alpha Go.

<!--more-->

### 步骤

1 选择: 选择能够最大化UCB值的节点

```
UCB = Vi+c*sqot(lnN/ni) c=2
```

2 扩展: 创建一个或多个子节点

3 仿真: 在某一结点用随机策略进行游戏

4 反向传播: 使用随机搜索的结果更新整个搜索树

5 在棋类游戏中应用mcts，本例将用五子棋应用mcts实现，实现五子棋的文件目录如下：

```python
---gomoku
	--board.py
	--mcts.py
	--node.py
	--play.py
```

 然后就可以一个一个实现了，首先是board，我们需要首先实现board类其需要一些属性

```size ```表示棋盘大小

```board ```传入一个board，若为空，则用numpy初始化一个

```cur_player``` 当前游戏玩家

其代码如下：

```python
class Board():
    def __init__(self, board=None, size=8, cur_player=-1):
        self.size = size
        self.board = np.zeros((self.size, self.size), int) if board is None else board
        self.cur_player = cur_player
```

然后需要实现几个函数：

```is_move_legal``` 判断棋子是否合法

```get_legal_pos``` 返回列表，得到棋盘位置为0点返回

```move```  落子操作，先判断棋子是否合法，则新生成一个Board对象，并将当前的move位置添加到棋盘上返回

```board_result``` 判断哪方赢。

```game_over``` 判定游戏是否结束

接下来一一实现，其代码如下：

```python
    def is_move_legal(self, move_pos):
        """
        :param move_pos: 元组得到位置
        :return: true or false
        """
        x, y = -100, -100
        if move_pos is not None:
            x, y = move_pos[0], move_pos[1]
        if x < 0 or x > self.size or y < 0 or y > self.size:  # 判断是否溢出棋盘边界
            return False
        if self.board[x, y] != 0:  # 判断是否下在已经有棋子的位置上
            return False
        return True

    def get_legal_pos(self):
        """
        :return: 返回列表
        """
        pos_list = []
        for i in range(0, self.size):
            for j in range(0, self.size):
                if self.board[i][j] == 0:
                    pos_list.append((i, j))
        return pos_list

    def move(self, move_pos):
        """
        走子
        :param move_pos:
        :return: board
        """
        if not self.is_move_legal(move_pos):  # 不合法
            return '棋子不合法'
        new_board = Board(np.copy(self.board), cur_player=-self.cur_player)
        new_board.board[move_pos[0]][move_pos[1]] = self.cur_player
        return new_board

    def board_result(self, move_pos):
        """
        :param move_pos:
        :return: 判断哪方赢
        """

        x, y = move_pos[0], move_pos[1]
        # print(x,y)
        player = self.board[x,y]
        direction = list([[self.board[i][y] for i in range(self.size)]])  # 纵向是否有五颗连子
        direction.append([self.board[x][j] for j in range(self.size)])  # 横向是否有五颗连子
        direction.append(self.board.diagonal(y - x))  # 该点正对角是否有五颗连子
        direction.append(np.fliplr(self.board).diagonal(self.size - 1 - y - x))  # 该点反对角是否有五颗连子
        for i in direction:
            count = 0
            for v in i:
                if v == player:
                    count += 1
                    if count == 5:
                        return True
                else:
                    count = 0
        return False

    def game_over(self, move_pos):
        """
        判断游戏是否结束，
        :param move_pos:
        :return:
        """
        if self.board_result(move_pos):
            return "win"
        elif len(self.get_legal_pos()) == 0:
            return 'tie'
        else:
            return None

```

实现完棋盘后，还需要实现游戏树节点，也就是```node```文件，其包含判定游戏树节点的一些操作，定义```Node```其属性具体如下：

```python
    def __init__(self, board=None, parent=None, pre_pos=None):
        self.pre_pos = pre_pos # 最后一次落子位置
        self.board = board  # 棋盘
        self.parent = parent  # 父节点
        self.children = list()
        self.not_visit_pos = None  # 未访问节点
        self.num_of_visit = 0  # 该节点访问次数
        self.num_of_wins = defaultdict(int)  # 该节点胜利次数
```

```fully_expended```   判断节点是否完全展开

```non_terminal```   是否为终端节点，即该节点对应的格局是否已分出胜负

```pick_unvisited```  选择一个未访问的节点并加入当前节点的孩子中

```pick_random```  随机选择该节点的一个孩子扩展

```num_of_win ```  判断该节点的胜负情况，利用一个实数即可代表黑白二子的胜负差值

```best_uct```  根据uct公式计算最优的孩子节点

具体实现如下：

```python
    def fully_expended(self):
        """
        判断节点是否完全展开
        :return: TRUE FALSE
        """
        if self.not_visit_pos is None:
            self.not_visit_pos = self.board.get_legal_pos()
        return True if len(self.not_visit_pos) == 0 and len(self.children) != 0 else False

    def non_terminal(self):
        """
        是否为终端节点，即该节点对应的格局是否已分出胜负
        :return:
        """
        game_result = self.board.game_over(self.pre_pos)
        return game_result

    def pick_unvisited(self):
        """
        选择一个未访问的节点并加入当前节点的孩子中
        :return:
        """
        random_index = random.randint(0, len(self.not_visit_pos) - 1)
        move_pos = self.not_visit_pos.pop(random_index)
        new_board = self.board.move(move_pos)
        new_node = Node(new_board, self, move_pos)
        self.children.append(new_node)
        return new_node

    def pick_random(self):
        """
        随即选择该节点的一个孩子扩展
        :return:
        """
        possible_moves = self.board.get_legal_pos()
        random_index = random.randint(0,len(possible_moves) - 1)
        new_board = self.board.move(possible_moves[random_index])
        new_node = Node(new_board, self, possible_moves[random_index])
        return new_node

    def num_of_win(self):
        """
        判断该节点的胜负情况，利用一个实数即可代表黑白二子的胜负差值
        :return:
        """
        win = self.num_of_wins[-self.board.cur_player]
        lose = self.num_of_wins[self.board.cur_player]

        return win - lose

    def best_uct(self, c_param=1.98):
        uct_of_child = np.array(list(
            [child.num_of_win() / child.num_of_visit + c_param * np.sqrt(self.num_of_visit) / child.num_of_visit for
             child in self.children]))
        best_index = np.argmax(uct_of_child)
        return self.children[best_index]
```

接下来是mcts实现，mcts其具体包含四个步骤，开篇已经提到了，接下来我们将具体实现

```python
# 到达叶结点
def traverse(node):
    while node.fully_expended():
        node = node.best_uct()
    if node.non_terminal() is not None: #
        return node
    else:
        return node.pick_unvisited()
  
# 然后进行随机模拟
def rollout(node):
    while True:
        game_result = node.non_terminal()
        if game_result is None:
            node = node.pick_random()
        else:
            break
    if game_result == 'win' and -node.board.cur_player == 1:
        return 1
    elif game_result == 'win':
        return -1
    else:
        return 0
 # 回溯，将模拟的值依次回溯至父节点
def backpropagate(node, result):
    node.num_of_visit += 1
    node.num_of_wins[result] += 1
    # print("backpropagate run")
    if node.parent:
        backpropagate(node.parent, result)
        # print("backpropagate run")
        
        
 # 根据uct公式选择最好的下一步
def best_child(node):
    visit_num_of_children = np.array(list([child.num_of_visit for child in node.children]))
    # print(visit_num_of_children)
    best_index = np.argmax(visit_num_of_children)
    node = node.children[best_index]
    return node


# mcts 可以循环很多次，进而促进多的模拟对局，才能选出更好的下一步

def mcts(board, pre_pos):
    root = Node(board=board, pre_pos=pre_pos)  # 根节点作为第一个node
    # print('mcts pre_pos:{}'.format(root.pre_pos))
    for i in range(0, mcts_times): # 循环 mcts_times为你要模拟多少次
        leaf = traverse(root)  # 到达叶结点
        # print("----------traverse run")
        simulation_result = rollout(leaf) # 随机模拟
        # print(simulation_result)
        backpropagate(leaf, simulation_result) # 回溯

    return best_child(root).pre_pos # 返回最好的下一步

```

定义完成之后接下来就可以进行对局了，也就是```play```文件，其具体实现如下：

定义```play```,其属性包含```board```,然后实现```print_board```打印棋盘,```startplay``` 开始对局，依次实现，代码如下

```python
from board import Board
from board import Human
from board import AI
ALPHABET = 'A B C D E F G H I J K L M N O'
class play():
    def __init__(self):
        self.board = Board()
    
    def print_board(self):
        # width, height = self.board.size, self.board.size  # 棋盘大小

        print("黑子(-1) 用 X 表示\t白子(1) 用 O 表示")
        #
        # for x in range(width):  # 打印行坐标
        #     print("{0:8}".format(x), end='')
        board_str = '\n   ' + ALPHABET[:self.board.size * 2 - 1] + '\n'
        board = self.board
        for i in range(self.board.size):
            for j in range(self.board.size):
                if j == 0:
                    board_str += '{:2}'.format(i + 1)
                if board.board[i, j] == -1:
                    board_str += ' X'
                elif board.board[i, j] == 1:
                    board_str += ' O'
                else:
                    board_str += ' .'
                if j == self.board.size - 1:
                    board_str += '\n'
        # board_str += '  '
        print(board_str)
        
    def startplay(self):
        human,ai = Human(),AI()
        self.print_board()
        while True:
            self.board,move_pos = human.action(self.board)
            game_result = self.board.game_over(move_pos)
            self.print_board()
            if game_result == 'win' or game_result=='tie':
                print('黑子落棋:{},(-1)胜利，game over\n'.format(move_pos)) if game_result == 'win' else print('黑子落棋:{}, 平局\n'.format(move_pos))
                break
            else:
                print('黑子落棋:{},未分胜利\n'.format(move_pos))
            start = time.time()
            self.board, move_pos = ai.action(self.board,move_pos)
            finish = time.time()-start
            # print('ai')
            # print(move_pos)
            game_result = self.board.game_over(move_pos)
            self.print_board()
            if game_result == 'win' or game_result=='tie':
                print('白子落棋:{},(1)胜利，time:{:0.0f}s game over\n'.format(move_pos,finish)) if game_result == 'win' else print('白子落棋:{}, time:{:0.0f}s 平局\n'.format(move_pos,finish))
                break
            else:
                print('白子落棋:{}, time:{:0.0f}s 未分胜利\n'.format(move_pos,finish))
    
```

``` startplay```   中包含两个角色，所以在```board```中定义两个角色，分别实现```action```的动作，也就是先通过```mcts```找到最好的```move```  ,然后走子，返回棋盘和当前的走子位置。

定义```human```类:

```python
class Human():
    def __init__(self, player=-1):
        self.player = player

    def get_action_pos(self, board):
        """
        读取用户输入的数据
        :param board:
        :return:
        """
        try:
            location = input("输入坐标x,y:")
            if isinstance(location, str) and len(location.split(",")) == 2:
                move_pos = tuple([int(i) for i in location.split(',')])
            else:
                move_pos = -1
        except:
            move_pos = -1

        if move_pos == -1 or move_pos not in board.get_legal_pos():
            print('落子位置错误')
            move_pos = self.get_action_pos(board)

        # print('get_action_pos----{}'.format(move_pos))
        return move_pos
    
    
    def action(self, board):
        """
        获得用户落子后的棋盘格局
        :param board:
        :return:board,move_pos
        """
        move_pos = self.get_action_pos(board)
        board = board.move(move_pos)
        return board, move_pos
```

定义```AI```：

```python
class AI():
    def __init__(self, player=1):
        self.player = player

    def action(self,board,pre_pos):
        move_pos = mcts(board,pre_pos)
        board = board.move(move_pos)
        return board,move_pos
```

至此，一个以mcts实现的五子棋实现完毕！！！。







