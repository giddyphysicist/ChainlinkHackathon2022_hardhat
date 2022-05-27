// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

contract Exchange {
    uint256 x;
    uint256 y;
    uint256 dy;
    uint256 dx;
    uint256 qnum; // numerator for q-value : can only take values of 0, 5, or 10 for now.
    // uint256 qdenom; // denominator for q-value. for now, assume this is always 10. 
    uint256 k;
    uint256 qsign; // qsign == 0 for negative q-values, otherwise assume q is positive.

    constructor(uint256 _x, uint256 _y, uint256 _qsign, uint256 _qnum) {
        x = _x;
        y = _y;
        require(_qnum == 0 || _qnum == 5 || _qnum == 10, "INVALID Q VALUE -- _QNUM MUST BE 0, 5, or 10.");
        qnum = _qnum;
        qsign = _qsign;
        // qdenom = _qdenom; // for now, assume this is always 10. 
        updateK(_x, _y, _qsign, _qnum);
        // ktotheq = (_qnum * log2IntegerPart(_x) / _qdenom) + (_qnum * log2IntegerPart(_y) / _qdenom);

    }   

    function updateQ(uint256 _qsign, uint256 _qnum) public { // DEBUG: making this public for now for testing
        require(_qnum == 0 || _qnum == 5 || _qnum == 10, "INVALID Q VALUE -- _QNUM MUST BE 0, 5, or 10.");
        qnum = _qnum;
        qsign = _qsign;
        // need to update k based on new q value:
        updateK(x, y, _qsign, _qnum);
    }

    function updateK(uint256 _x, uint256 _y, uint256 _qsign, uint256 _qnum) public { // DEBUG: making this public for now for testing
        require(_qnum == 0 || _qnum == 5 || _qnum == 10, "INVALID Q VALUE -- _QNUM MUST BE 0, 5, or 10.");

        if (_qnum == 0) {
            // q = 0 : constant-product
            k = _x * _y;
        }
        else if (_qsign == 0 && _qnum == 5) {
            // q = -1/2
            k = _x*_y / (_x + _y + 2*sqrt(_x*_y));
        }
        else if (_qsign == 0 && _qnum == 10) {
            // q = -1 : harmonic mean
            k = _x*_y/(_x+_y);
        }
        else if (_qsign > 0 && _qnum == 5) {
            // q = 1/2
            k = _x + _y + 2*sqrt(_x*_y);
        } else {
            // q = 1 : constant sum
            k = _x + _y;
        }
        

    }

    function getX() public view returns(uint256) {
        return x;
    }

    function getY() public view returns(uint256) {
        return y;
    }

    function getDY() public view returns(uint256) {
        return dy;
    }

    function getQnum() public view returns(uint256) {
        return qnum;
    }

    function getQnumString() public view returns(string memory) {
        uint256 qs = qsign;
        uint256 qn = qnum;
        if (qs == 0 && qn == 10) {
            return "-1.0";}
        if (qs == 0 && qn == 5) {
            return "-0.5";}  
        if (qn == 0) {
            return "0.0";}
        if (qn == 5) {
            return "0.5";}
        if (qn == 10) {
            return "1.0";}
        return "";
    }

    function swapXforY(uint256 _dx) public {
        require(_dx>0,"INPUT DX MUST BE POSITIVE");
        uint256 newx = x + _dx;
        uint256 newy = y;
        
        // q = -1: Harmonic mean
        if (qsign == 0 && qnum == 10) {
        require(newx > k, "INVALID DX VALUE -- MUST BE LARGER THAN K");
        // uint256 k = x * y / (x+y);
        uint256 denom = newx -  k;
        newy = k * newx / denom;
        }

        // q = -1/2: 1 / (1/sqrt(x) + 1/sqrt(y)) = k
        else if (qsign == 0 && qnum == 5) {
        require(newx > k, "INVALID DX VALUE -- MUST BE LARGER THAN K");
        // uint256 sqrtXpDX = sqrt(newx);
        // uint256 sqrtK = sqrt(k);
        // uint256 num = sqrtK * sqrtXpDX;
        // uint256 denom = sqrtXpDX - sqrtK;
        // newy = num / denom;
        newy = k * newx / (newx + k - 2*sqrt(k * newx));
        }

        // q = 0: constant product
        else if (qnum == 0) {
            newy = x * y / newx;
        }
        
        // q = 1/2: (sqrt(x) + sqrt(y))**2 = k

        else if (qsign > 0 && qnum == 5) {
            // uint256 sqrtXpDX = sqrt(newx);
            // uint256 sqrtK = sqrt(k);
            newy = k + newx - 2*sqrt(k*newx);
            // uint256 newy = (sqrtK - sqrtXpDX) ** 2;

        }
        // q = 1: constant sum.
        // not implemented here.
        else {
            require(k>newx,"NOT ENOUGH RESERVES");
            newy = k - newx;
        }

        dy = y - newy;

        x = newx;
        y = newy;
    }

    function swapYforX(uint256 _dy) public {
        require(_dy>0,"INPUT DX MUST BE POSITIVE");
        uint256 newy = y + _dy;
        uint256 newx = x;
        
        // q = -1: Harmonic mean
        if (qsign == 0 && qnum == 10) {
        require(newx > k, "INVALID DX VALUE -- MUST BE LARGER THAN K");
        // uint256 k = x * y / (x+y);
        uint256 denom = newx -  k;
        newx = k * newy / denom;
        }

        // q = -1/2: 1 / (1/sqrt(x) + 1/sqrt(y)) = k
        else if (qsign == 0 && qnum == 5) {
        require(newy > k, "INVALID DY VALUE -- MUST BE LARGER THAN K");
        // uint256 sqrtXpDX = sqrt(newx);
        // uint256 sqrtK = sqrt(k);
        // uint256 num = sqrtK * sqrtXpDX;
        // uint256 denom = sqrtXpDX - sqrtK;
        // newy = num / denom;
        newx = k * newy / (newy + k - 2*sqrt(k * newy));
        }

        // q = 0: constant product
        else if (qnum == 0) {
            newx = x * y / newy;
        }
        
        // q = 1/2: (sqrt(x) + sqrt(y))**2 = k

        else if (qsign > 0 && qnum == 5) {
            // uint256 sqrtXpDX = sqrt(newx);
            // uint256 sqrtK = sqrt(k);
            newx = k + newy - 2*sqrt(k*newy);
            // uint256 newy = (sqrtK - sqrtXpDX) ** 2;

        }
        // q = 1: constant sum.
        // not implemented here.
        else {
            require(k>newy,"NOT ENOUGH RESERVES");
            newx = k - newy;
        }

        dx = x - newx;

        x = newx;
        y = newy;
    }

    // function log2IntegerPart(uint256 xxx) public pure returns(uint256) {
    //     uint256 xx = xxx;
    //     uint256 n;
    //     if (xx >= 2**128) { xx >>= 128; n += 128; }
    //     if (xx >= 2**64) { xx >>= 64; n += 64; }
    //     if (xx >= 2**32) { xx >>= 32; n += 32; }
    //     if (xx >= 2**16) { xx >>= 16; n += 16; }
    //     if (xx >= 2**8) { xx >>= 8; n += 8; }
    //     if (xx >= 2**4) { xx >>= 4; n += 4; }
    //     if (xx >= 2**2) { xx >>= 2; n += 2; }
    //     if (xx >= 2**1) { /* x >>= 1; */ n += 1; }
    //     return n;
    // }


    // function complexSwap(uint256 dx) public {
    //     uint256 newx = x + dx;
    //     uint256 kq = ktotheq;
    //     uint256 m_qnum = qnum;
    //     uint256 m_qdenom = qdenom;
    //     // newy = (k**q - (newx)**q)**1/q
    //     // first, suppose q = 1/5. 
    //     uint256 newxToTheQ = 2**(m_qnum * log2IntegerPart(newx) / m_qdenom);
    //     uint256 newybase = (kq - newxToTheQ);
    //     uint256 newy = 2**(m_qdenom * log2IntegerPart(newybase) / m_qnum);
    //     x = newx;
    //     y = newy;

    // }

    // credit for this implementation goes to
    // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
    function sqrt(uint256 x1) internal pure returns (uint256) {
        if (x1 == 0) return 0;
        // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
        // however that code costs significantly more gas
        uint256 xx = x1;
        uint256 r = 1;
        if (xx >= 0x100000000000000000000000000000000) {
            xx >>= 128;
            r <<= 64;
        }
        // else z = 0
        if (xx >= 0x10000000000000000) {
            xx >>= 64;
            r <<= 32;
        }
        if (xx >= 0x100000000) {
            xx >>= 32;
            r <<= 16;
        }
        if (xx >= 0x10000) {
            xx >>= 16;
            r <<= 8;
        }
        if (xx >= 0x100) {
            xx >>= 8;
            r <<= 4;
        }
        if (xx >= 0x10) {
            xx >>= 4;
            r <<= 2;
        }
        if (xx >= 0x8) {
            r <<= 1;
        }
        r = (r + x1 / r) >> 1;
        r = (r + x1 / r) >> 1;
        r = (r + x1 / r) >> 1;
        r = (r + x1 / r) >> 1;
        r = (r + x1 / r) >> 1;
        r = (r + x1 / r) >> 1;
        r = (r + x1 / r) >> 1; // Seven iterations should be enough
        uint256 r1 = x1 / r;
        return (r < r1 ? r : r1);
    }


}