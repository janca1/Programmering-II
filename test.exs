defmodule Test do

  def double(n) do
    n+n
  end

  def ftc(x) do
    (x-32)/1.8
  end

  def rec(a,b) do
    a*b
  end

  def sq(a) do
    rec(a,a)
  end

  def circle(r) do
    :math.pi*r*r
  end

  def product(m,n) do
    cond do
      m == 0 -> 0
      n == 0 -> 0
      true -> product(m-1, n) + n
    end
  end

  def exp(x, n) do
    cond do
      n == 0 -> 1
      n == 1 -> x
      rem(n,2) == 0 -> product(exp(x, n/2), x)
      rem(n,2) == 1 -> product(exp(x, n-1), x)
    end
  end

  def nth(n, [head | tail]) do
    cond do
      n == 1 -> head
      true -> nth(n-1, tail)
    end
  end

  def len([]) do 0 end
  def len([_head | tail]) do
      1 + len(tail)
  end

  def sum([]) do 0 end
  def sum([head | tail]) do
     head + sum(tail)
  end

  def duplicate([]) do [] end
  def duplicate([head | tail]) do
    [head, head | duplicate(tail)]
  end

  def add(x, []) do [x] end
  def add(x, [x | tail]) do
    [x | tail]
  end
  def add(x, [head | tail]) do
    [head | add(x, tail)]
  end

  def remove(_, []) do [] end
  def remove(x, [head | tail]) do
    cond do
      x == head -> remove(x, tail)
      true ->  [head | remove(x, tail)]
    end
  end

  def unique([]) do [] end
  def unique([x | tail]) do
    [x | unique(remove(x, tail))]
  end

  def reverse([]) do [] end
  def reverse([head | tail]) do
    reverse(tail) ++ [head]
  end


  def insert(element, []) do [element] end
  def insert(element, [head | tail]) when element > head do
    [head | insert(element, tail)]
  end
  def insert(element, largerElement) do
    [element | largerElement]
  end

  def isort(l) do isort(l, []) end
  def isort(l, sorted) do
    case l do
      [] -> sorted
      [h | t] -> isort(t, insert(h, sorted))
    end
  end


  def msort(l) do
    case l do
      [] -> []
      [x] -> [x]
      [h | t] -> {l1, l2} = msplit(l, [], [])
    merge(msort(l1), msort(l2))
    end
  end

  def merge(subl1, []) do subl1 end
  def merge([], subl2) do subl2 end
  def merge([h1 | t1], [h2 | t2]) do
    if h1 < h2 do
      [h1 | merge(t1, [h2 | t2])]
    else
      [h2 | merge([h1 | t1], t2)]
    end
  end

  def msplit(l, subl1, subl2) do
    case l do
      [] -> {subl1, subl2}
      [h | t] -> msplit(t, [h | subl2], subl1)
    end
  end


  def qsort([]) do [] end
  def qsort([p | l]) do
    {l1, l2} = qsplit(p, l, [], [])
    small = qsort(l1)
    large = qsort(l2)
    append(small, [p | large])
  end

  def qsplit(_, [], small, large) do {small, large} end
  def qsplit(p, [h | t], small, large) do
    if h < p do
      qsplit(p, t, [h | small], large)
    else
      qsplit(p, t, small, [h | large])
    end
  end

  def append(l1, l2) do
    case l1 do
    [] -> l2
    [h | t] ->  [h | append(t, l2)]
    end
  end


  def nreverse([]) do [] end
  def nreverse([h | t]) do
    r = nreverse(t)
    append(r, [h])
  end

  def reverseT(l) do
    reverseT(l, [])
  end
  def reverseT([], r) do r end
  def reverseT([h | t], r) do
    reverseT(t, [h | r])
  end

  def bench() do
      ls = [16, 32, 64, 128, 256, 512]
      n = 100
      # bench is a closure: a function with an environment.
      bench = fn(l) ->
      seq = Enum.to_list(1..l)
      tn = time(n, fn -> nreverse(seq) end)
      tr = time(n, fn -> reverseT(seq) end)
      :io.format("length: ~10w nrev: ~8w us rev: ~8w us~n", [l, tn, tr])
    end
    # We use the library function Enum.each that will call
    # bench(l) for each element l in ls
      Enum.each(ls, bench)
    end
    # Time the execution time of the a function.
    def time(n, fun) do
      start = System.monotonic_time(:millisecond)
      loop(n, fun)
      stop = System.monotonic_time(:millisecond)
      stop - start
    end
    # Apply the function n times.
    def loop(n, fun) do
      if n == 0 do
        :ok
      else
        fun.()
        loop(n - 1, fun)
    end
  end


  def to_binary(0) do [] end
  def to_binary(n) do
    append(to_binary(div(n, 2)), [rem(n, 2)])
  end

  def to_better(n) do to_better(n, []) end
  def to_better(0, b) do b end
  def to_better(n, b) do
    to_better(div(n, 2), [rem(n, 2) | b])
  end

  def to_integer(x) do to_integer(x, 0) end
  def to_integer([], n) do n end
  def to_integer([x | r], n) do
    to_integer(r, 2 * n + x)
  end


  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do
    fib(n - 1) + fib(n - 2)
  end

  def bench_fib() do
    ls = [8,10,12,14,16,18,20,22,24,26,28,30,32]
    n = 10

    bench = fn(l) ->
      t = time(n, fn() -> fib(l) end)
      :io.format("n: ~4w  fib(n) calculated in: ~8w us~n", [l, t])
    end

    Enum.each(ls, bench)
  end

end
