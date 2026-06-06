## A simple queue implementation with basic operations:
## [code]push[/code], [code]pop[/code], [code]first[/code],
## [code]is_empty[/code], and [code]length[/code].
class_name Queue
extends Object

var _items: Array = []

func new():
    _items = []

func clear():
    _items.clear()

func queue_free():
    _items.clear()

func peek()->Variant:
    if !is_empty():
        return _items[0]
    return null

func push(item):
    _items.append(item)

func pop()->Variant:
    if !is_empty():
        return _items.pop_front()
    return null

func is_empty()->bool:
    return length() == 0

func length()->int:
    return _items.size()

func reverse()->Queue:
    var reversed_queue = Queue.new()
    for i in range(length() - 1, -1, -1):
        reversed_queue.push(_items[i])
    return reversed_queue

func _to_string()->String:
    super.to_string()  # Call the base class's to_string() method
    var queue_string : String = "Queue: ["
    for i in range(length()):
        queue_string += str(_items[i])
        if i < length() - 1:
            queue_string += ", "
    queue_string += "]"
    return queue_string