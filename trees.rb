BinaryTree = Struct.new(:data, :left, :right, :count) do
  def left_or_right(stuff)
    (rand(1023) % 2) == 1 ? :left : :right
  end

  def add(stuff)
    direction = left_or_right(stuff)
    if direction == :left
      if left == nil
        self.left = self.class.new(stuff, nil, nil)
      else
        self.left = self.left.add(stuff)
      end
    elsif direction == :right
      if right == nil
        self.right = self.class.new(stuff, nil, nil)
      else
        self.right = self.right.add(stuff)
      end
    else
      self.count = 1 if self.count.nil?
      self.count += 1
    end
    return self
  end

  def is_leaf?
    self.left.nil? && self.right.nil?
  end

  def parent_of_one?
    !is_leaf && (self.left.nil? || self.right.nil?)
  end

  def only_child
    right if left.nil?
    left if right.nil?
  end

  def mirror
    return self if self.is_leaf?
    left_mirror  = left.nil? ? nil : left.mirror
    right_mirror = right.nil? ? nil : right.mirror
    self.left, self.right = right_mirror, left_mirror
    return self
  end

  def to_s
    left.to_s + ' ' + data.to_s + (count.nil? ? '' : "[#{count}]") + ' ' + right.to_s
  end

  def height_of_tree(tree)
    return 0 if tree.nil?
    return 1 if tree.is_leaf?
    return 1 + [height_of_tree(tree.left), height_of_tree(tree.right)].max
  end

  def height
    height_of_tree(self)
  end

  def level_print
    level = [self]
    output = ''
    while not level.compact.empty?
      output += level.map { |node| node.nil? ? "_" : node.data.to_s }.join('  ') + "\n"
      level  = level.map {|node| [node.left, node.right] unless node.nil?  }.flatten
    end
    return output
  end

end

class BinarySearchTree < BinaryTree
  def left_or_right(stuff)
    return :left if stuff < self.data
    return :here if stuff == self.data
    return :right if stuff > self.data
  end
end

class AVLTree < BinarySearchTree

  def imbalance(node)
    return 0 if node.nil?
    lheight = height_of_tree(node.left)
    rheight = height_of_tree(node.right)
    lheight - rheight
  end

  def LR(node)
    node.left = R(node.left)
    return L(node)
  end

  def RL(node)
    node.right = L(node.right)
    return R(node)
  end

  def L(node)
    return nil if node.nil?
    left_child = node.left
    return node if left_child.nil?
    node.left  = left_child.right
    left_child.right = node
    return left_child
  end

  def R(node)
    return nil if node.nil?
    right_child = node.right
    return node if right_child.nil?
    node.right = right_child.left
    right_child.left = node
    return right_child
  end

  def balance(node)
    diff = imbalance(node)
    return node if diff.abs < 2

    # less than zero: right is heavier
    if diff < 0
      return RL(node) if imbalance(node.right) == 1
      return R(node)
    end

    # more than zero: left is heavier
    return LR(node) if imbalance(node.left) == -1
    return L(node)
  end

  def add(stuff)
    super
    return balance(self)
  end
end

tree = AVLTree.new(9, nil, nil)
6.times do
  tree = tree.add(rand(100))
end
puts tree
#puts tree.mirror
puts tree.mirror
puts tree.level_print
puts tree.height
