Node = Struct.new(:data, :next) do
  def go_fwd_k(k)
    raise "Error" if k < 0
    return self, k if k.zero? || self.next.nil?
    return self.next.go_fwd_k(k - 1)
  end

  def go_to_end
    return self if self.next.nil?
    return self.next.go_to_end
  end

  def self.k_from_end(node, k)
    return node.k_from_end(k) unless node.nil?
  end

  def k_from_end(k)
    return self.go_to_end if k.zero?
    f1, x = self.go_fwd_k(k)
    return nil if x != 0

    head = self
    while true do
      f2, x = f1.go_fwd_k(k)
      return head.go_fwd_k(k - x).first unless x.zero?
      head = f1
      f1 = f2
    end
  end

  def reverse
    return Node.reverse(self).first
  end

  def self.reverse(node)
    return node, node if node.nil? || node.next.nil?
    head, tail = reverse(node.next)
    node.next = nil
    tail.next = node
    return head, node
  end

  def self.iter_reverse(node)
    return nil if node.nil?
    todo = node.next
    while not todo.nil?
      temp = todo
      todo = todo.next
      temp.next = node
      node = temp
    end
    return node
  end

  def to_s
    return data.to_s if self.next.nil?
    data.to_s + ": " + self.next.to_s
  end
end

class LinkedList

  def initialize(head = nil)
    @head = head
  end

  def add(data)
    @head = Node.new(data, @head)
  end

  def pop_head()
    return nil if @head.nil?
    x = @head.data
    @head = @head.next
    return x
  end

  def is_empty?()
    @head.nil?
  end

  def go_fwd_k(k)
    return @head.go_fwd_k(k) unless @head.nil?
  end

  def tail
    @head.go_to_end unless @head.nil?
  end

  def k_from_end(k)
    Node.k_from_end(@head, k) unless @head.nil?
  end

  def reverse
    @head = @head.reverse unless @head.nil?
  end

  def to_s
    @head.to_s unless @head.nil?
  end
end


x = LinkedList.new()
loopsize = 30
inputsize = 50
ksize = 12
prime = 17
loopsize.times do
  puts x.to_s
  r = rand(loopsize * inputsize * ksize * 3 * 19)
  if r % prime == 0
    puts "pop"
    puts x.pop_head()
  elsif r % prime == 1
    puts "tail"
    puts x.tail
  elsif r % prime == 2
    k = rand(ksize)
    puts "#{k} from end"
    y = x.k_from_end(k)
    puts y.to_s
  elsif r % prime == 3
    puts "reverse"
    x.reverse
  else
    x.add(rand(inputsize))
  end
  puts x.to_s
end
