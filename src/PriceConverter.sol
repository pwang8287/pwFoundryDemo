// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// 从GitHub引用一个chainlink预言机的接口合约对象
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    // 这个函数通过调用chainlink的喂价接口获得了ETH与USD的汇率，当然这个例子中使用的是sepolia的虚拟网络
    function getPrice(
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        // ABI
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(
        //     0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ); // 从接口的地址实例化一个合约对象
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // ETH in terms of USD
        //3000.00000000
        return uint256(answer * 1e10); //这一行确保返回值只有10位小数，方法是通过将小数乘以10的10次方然后取整数部分
    }

    function getConversionRate(
        uint256 ethAmount,
        AggregatorV3Interface priceFeed
    ) internal view returns (uint256) {
        uint256 ethPrice = getPrice(priceFeed);
        // 3000_000000
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18; //先相乘再除以1e18是为了让两个18位小数的数值的乘积只保留18位小数，否则会得到36位小数
        return ethAmountInUsd;
    }
}
