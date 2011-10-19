require 'set'

# This is the main class.
# You will have to have one initialisation of this for every pagination.
#
class Pagina
    # * *Arguments* :
    #   - +len+ ->  the number of elements that we are paginating.
    #   - +perpage+ ->  the number of elements we want per page (must be an odd number greater than 4).
    # * *Returns* :
    #   - +Pagina+ object.
    # * *Raises*  :
    #   - +ArgumentError+ -> if +perpage+ < 5 || (+perpage+ % 2) != 1
    def initialize len, perpage
        @len     = len
        if perpage < 5 or (perpage % 2 != 1) then
            raise ArgumentError.new(%[Per page should be odd number > 4.])
        end
        @perside = (perpage - 2) / 2
    end

    # This method lays out the navigation bar.
    # * *Arguments* :
    #   - +pos+ ->  The page for which we are rendering the navigation bar.
    #   - +sep+ ->  The string that will be placed between any two navigation links. The default is +&bull;+, the HTML bullet.
    #   - +mid+ ->  The string to be placed where navigation links would have gone, but where they have been removed for the sake of having a brief navigation panel. The default is +&#133;+, the HTML three-dot diaeresis (...).
    #   - +block+ -> The block is given two arguments, the first being the navigation position, the second being a boolean indicator of whether this navigation position is the current page. The block should return a string, which is how the navigation bar is filled.
    def nav pos, sep = ' &bull; ', mid = ' &#133; '
        lft = Set.new((pos - (@perside + 1) .. (pos - 1)).to_a)
        rgt = Set.new(((pos + 1) .. (pos + 1 + @perside)).to_a)
        dem = ((lft.member?(1) or (pos == 1)) ? [] : [yield(1, false), (lft.member?(2) ? sep : mid)]) +
                [lft.to_a.select {|x| x > 0}.sort.map do |x|
                    yield(x, false)
                end.join(sep)] + (pos == 1 ? [] : [sep]) +
                    [yield(pos, true)] + (pos == @len ? [] : [sep]) +
                        [rgt.to_a.select {|x| x <= @len}.sort.map do |x|
                            yield(x, false)
                        end.join(sep)] +
                            ((rgt.member?(@len) or (pos == @len)) ? [] :
                                [(rgt.member?(@len - 1) ? sep : mid), yield(@len, false)])
        dem.join
    end
end
