function fib(m)
  if m < 2 then
    return m
  end
  return fib(m-1) + fib(m-2)
end

return fib(15);
