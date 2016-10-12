def divisors(d)
    limit = Math::sqrt(98).to_i
    i = 1
    l = []
    while i <= limit
        if d % i == 0
            l.push(i)
            k = d/i
            l.push(k) if i != k
        end
        i += 1
    end
    l
end

p divisors(12).uniq