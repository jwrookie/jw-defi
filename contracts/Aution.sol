//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Aution {
    address payable public seller; //卖方
    address payable public buyer; //买方
    uint256 public highAmount; //最高价
    address payable public admin; //管理员(平台方)
    string autionName; //拍卖物品
    bool isFinshed; //是否拍卖结束
    uint256 outTime; //拍卖截止时间
    mapping (address => uint256) pendingReturns; // 用于取回之前的出价

    //最高出价变动时调用事件
    event HighestBidIncreased(address _bidder,uint256 _amount);

    //拍卖结束时调用事件
    event End_Auction(address _winner,uint256 _amount);

    //创建一个拍卖对象，初始化卖方、拍卖物品、拍卖时间
    constructor(address payable _seller,string memory _name){
        seller=_seller;
        autionName=_name;
        admin=payable(msg.sender); //管理员为部署该合约的账户
        outTime=block.timestamp+120; //拍卖时长为2分钟
        isFinshed=false;
        highAmount=0;
    }

    // 拍卖
    function aution() public payable{
        require(msg.value>highAmount,"amount must>highAmount");
        require(block.timestamp<=outTime,"must not time out");
        require(!isFinshed,"must not finshed");
        //每一次买方出价前返回上笔金额
        if (pendingReturns[msg.sender] > 0) {
            payable(msg.sender).transfer(highAmount);
        }
        buyer=payable(msg.sender); //最终买方的账户地址为本次调用合约的账户地址
        highAmount=msg.value;
        pendingReturns[buyer]=highAmount;
        emit HighestBidIncreased(msg.sender,msg.value);
    }

    // 未拍卖成功者取回之前的金额
    function withdraw() public returns (bool){
        require(msg.sender!=buyer,"msg.sender != buyer");
        uint256 amount = pendingReturns[msg.sender];
        require(amount>0,"amount must > 0 ");

        // 需要提前设置为0，因为接收者可以在这个函数结束前再次调用它
        pendingReturns[msg.sender] = 0;
        if (!payable(msg.sender).send(amount)){
            // 不需要throw，直接重置代币数量即可
            pendingReturns[msg.sender] = amount;
            return false;
        }
        return true;
    }

    //结束拍卖
    function endAuction()public payable{
      require(msg.sender==admin,"only admin can do this");
      require(block.timestamp>outTime,"time is not ok");
      require(!isFinshed,"must not finshed");
      isFinshed=true;
      emit End_Auction(buyer, highAmount);
      seller.transfer(highAmount*90/100); //支付90%的价格给卖方
    }

    // 当前合约地址
    function thisAddress() public view returns(address){
        return address(this);
    }

    // 当前合约的余额
    function thisBalance() public view returns(uint){
        return address(this).balance;
    }

    // 销毁合约
    function destruct() public payable{
        selfdestruct(admin);
    }
}