--
-- Created by IntelliJ IDEA.
-- User: ekhion
-- Date: 2021. 07. 03.
-- Time: 1:27
--

function addReward(state)

    math.randomseed(os.clock() * 1000000)
    math.random(); math.random(); math.random();

    local params = Config.action[state]
    local item
    local money, m1, m2 = 0, 0, 0

    if not params then

        return {
            item = '',
            money = 0,
            point = 0
        }
    end

    local drop = params.drop and params.drop or {}
    local sumW = 0

    if #drop > 0 then

        for i = 1, #drop do sumW = sumW + drop[i].weight end

        local rng = math.random(sumW)

        for i = 1, #drop do

            if rng <= drop[i].weight then

                local itemCount = #drop[i].item

                -- MONEY
                m1 = drop[i].money and drop[i].money[1] or 0
                m2 = drop[i].money and drop[i].money[2] or 0

                if m2 > m1 then

                    money = math.random(m1, m2)
                else

                    money = math.random(m2, m1)
                end

                -- ITEM
                if itemCount > 0 then

                    local itemIdx = math.random(itemCount)
                    item = drop[i].item[itemIdx]
                end

                break
            end

            rng = rng - drop[i].weight
        end
    end


    return {
        item = item and item or '',
        money = money and money or 0,
        point = params.point and params.point or 0,
    }
end