defmodule Derivate do
  @type literal() :: {:num, number()}
  | {:var, atom()}

  @type expr() :: {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | literal()
  | {:exp, expr(), literal()}

  def test1() do
    e = {:add,
      {:mul, {:num,2}, {:var, :x}},
      {:num, 4}}
      d = deriv(e, :x)
      IO.write(" expression: #{pprint(e)}\n")
      IO.write(" derivative: #{pprint(d)}\n")
      IO.write(" simplified: #{pprint(simplify(d))}\n")
      :ok
  end

  def test2() do
    e = {:add,
      {:exp, {:var, :x}, {:num, 3}},
      {:num, 4}}
      d = deriv(e, :x)
      IO.write(" expression: #{pprint(e)}\n")
      IO.write(" derivative: #{pprint(d)}\n")
      IO.write(" simplified: #{pprint(simplify(d))}\n")
      :ok
  end

  # includes ln(x), 1/x, sqrt(x) and sin(x)
  def test3() do
    e = {:add, {:add, {:add, {:mul, {:ln, {:var, :x}}, {:exp, {:var, :x}, {:num, 2}}},
    {:div, {:var, :x}}}, {:sqrt, {:var, :x}}}, {:sin, {:var, :x}}}

      d = deriv(e, :x)
      IO.write(" expression: #{pprint(e)}\n")
      IO.write(" derivative: #{pprint(d)}\n")
      IO.write(" simplified: #{pprint(simplify(d))}\n")
      :ok
  end

  def deriv({:num, _}, _) do {:num, 0} end
  def deriv({:var, v}, v) do {:num, 1} end
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do
    {:add, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:mul, e1, e2}, v) do
    {:add,
      {:mul, deriv(e1, v), e2},
      {:mul, e1, deriv(e2, v)}}
  end
  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n-1 }}},
      deriv(e, v)}
  end
  # ln(x)
  def deriv({:ln, {:var, v}}, v) do
    {:div, {:num, 1}, {:var, v}}
  end
  # 1/x
  def deriv({:div, {:var, v}}, v) do
    {:div, {:num, -1}, {:exp, {:var, v}, {:num, 2}}}
  end
   # √x
  def deriv({:sqrt, {:var, v}}, v) do
    {:div, {:num, 1}, {:mul, {:num, 2}, {:sqrt, {:var, v}}}}
  end
  # sin(x)
  def deriv({:sin, {:var, v}}, v) do
    {:cos, {:var, v}}
  end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, v}) do "#{v}" end
  def pprint({:add, e1, e2}) do "#{pprint(e1)} + #{pprint(e2)}" end
  def pprint({:mul, e1, e2}) do "#{pprint(e1)} * #{pprint(e2)}" end
  def pprint({:div, e1, e2}) do "(#{pprint(e1)}/#{pprint(e2)})" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)})^(#{pprint(e2)})" end
  def pprint({:ln, e}) do "ln(#{pprint(e)})" end
  def pprint({:div, e}) do "(1/#{pprint(e)})" end
  def pprint({:sqrt, e}) do "(1/sqrt(#{pprint(e)}))" end
  def pprint({:sin, e}) do "sin(#{pprint(e)})" end
  def pprint({:cos, e}) do "cos(#{pprint(e)})" end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:ln, e}) do {:ln, simplify(e)} end
  def simplify({:div, e}) do {:div, simplify(e)} end
  def simplify({:sqrt, e}) do {:sqrt, simplify(e)} end
  def simplify({:sin, e}) do {:sin, simplify(e)} end
  def simplify({:cos, e}) do {:cos, simplify(e)} end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1+n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1,n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

end
