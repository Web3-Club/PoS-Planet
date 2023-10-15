<h1 align="center">
  <span style="font-size: 32px;">PoS Planet</span>
</h1>


<h2 align="center">
  🧑‍🌾-🪙-🌾
</h2>

<h2 align="center">
  🪐 Buidl PoS the new planet in year of 3023. 
</h2>

![chainfarm](https://github.com/Web3-Club/Chain-Farm/assets/111333575/ed586a92-8491-4688-87f2-d3b51b06bb8b)

<br>

  > 人类的面前有两条路：

  > 一条向外，通往星辰大海；一条对内，通往虚拟现实。
  


<h2 align="center">
  基于 <b> Starknet-Dojo </b> 的科幻开放世界<sup>[1]</sup>全链游戏
</h2>

<p align="center">
  <a href="https://github.com/yanboishere/Chain.Food/blob/master/LICENSE">
    <img src="https://img.shields.io/github/license/Web3-Club/Chain-Farm?style=flat-square" alt="mit">
  </a>
  <a href="https://github.com/Web3-Club/Web3-Interactive-Learning">
    <img src="https://img.shields.io/github/stars/Web3-Club/Chain-Farm.svg?style=social&label=Stars" alt="GitHub stars">
  </a>
  <a href="https://github.com/Web3-Club/Blockchain-Developer-roadmap_Chinese">
    <img src="https://img.shields.io/github/watchers/Web3-Club/Chain-Farm.svg?style=social&label=Watch" alt="GitHub watchers">
  </a>
</p>




## 游戏简介

> 光明的未来和毁灭的深渊，这两个选项都略显极端，<br>
> 技术从来都是中性的 <br>
> 无谓善恶，掌握在不同的人手里，才会导致迥异的结局。<sup>[1]</sup>

3023年 经过200多轮的牛市的洗刷，即使在比特币区块奖励达到了 ***0.0000000000000000......*** 个情况下 地球被PoW的挖矿潮中被榨干了一切资源


本游戏即使在以上的故事背景下展开，一群人类尝试自救,尝试使用PoS的机制,真正**从0开始** 使用 **PoS** 来开发一个星球。


<br>
<br>
<br>
<br>
<br>



## Story





<br>
<br>
<br>
<br>
<br>




## 游戏属性

      在本次黑客松比赛日程期间已做完的玩法将会标🌟
      

### 土地属性

  不同属性的土地对应不同的种子种植要求。例如，火属性的土地只能种植火属性的种子，冰属性的土地只能种植冰属性的种子。这样，玩家需要选择正确的土地来种植相应的种子。


        土地属性限制


#### 土地需要何种属性？
  
  比如
  
  - 具有普通属性、冰属性或者火属性，以及另一些适用于玩法的属性
  
  
  - 我们必须使用 `is_claimed` 属性代表土地是否被开垦，以及 `seed` 代表土地种植了哪些种子？
  
  - 土地这个属性对应的数据是什么？
  
  | 属性 | 作用 | 备注 |
  | ---- | ----- | ----- |
  | `owner` | 土地所有者 | address |
  | `id` | 土地 ID，用于标识唯一土地 | 使用 `ctx.uuid()` |
  | `seed` | 标记土地上所种植的作物 | 此处应为植物的 `id` |
  | `property` | 土地具有的对种植有影响的属性 | 枚举类型，需要确定包含哪些属性 |
  
  - 对于 `property` ，目前准备包含以下属性:
  
    - `Normal` 普通属性，可以种植地球种子
    - `Hot` 炎热属性，作用待定，名称可修改
    - `Cold` 寒冷属性，作用待定，名称可修改
  
  **对于上述属性出现的几率待定**

                                  10% 极寒土地；10% 冰封种子
                                  10% 极热土地；10% 赤火种子
                                  80% 普通土地；0% 普通种子
                                

  
## 特殊效果

  当种子和土地属性匹配时，种子的生长速度可以加快，产量增加或者获得额外的奖励。
  
  火属性的种子在火属性的土地上生长得更快，可以获得更多的收获。

  | 生长时间 / h | 极寒土地 | 极热土地 | 普通土地 |
  | ---- | ----- | ----- | ----- |
  | 冰封种子 | 10 | x | 20 |
  | 赤火种子 | x | 10 | 20 |
  | 普通种子 | x | x | 100 |

<br>
<br>
<br>

## 障碍物

  当种子和土地属性不匹配时，可能会出现一些障碍物或者敌对生物，阻碍种子的生长。例如，如果火属性的种子种植在冰属性的土地上，可能会出现冰块覆盖种子，减缓生长速度。

  
<br>
<br>
<br>

## 异常变化

  有时候，种子和土地属性不匹配可能会带来意外的结果。例如，火属性的种子种植在冰属性的土地上，可能会导致土地上的冰融化，形成水源，使得其他种子的生长速度加快。

  
<br>
<br>
<br>
  
## 特殊种子

  除了地球普通农作物的种子，可以添加一些特殊的星球特有种子。这些特殊种子可能具有特殊属性或者能力，可以种植在对应的土地上，并带来独特的收获或效果。


  
<br>
<br>
<br>
  
## 魔法互动

  种植不匹配的种子和土地可以引发魔法互动。例如，火属性的种子种植在冰属性的土地上可能会导致火焰与冰结合，形成奇特的冰火效果，改变周围环境或产生特殊资源。




  
<br>
<br>
<br>
  
## 属性转换

  通过特殊的魔法或仪式，玩家可以尝试将不匹配的种子和土地属性进行转换。例如，使用特殊药剂或咒语将火属性的土地转换为冰属性，从而使原本无法生长的冰属性种子可以在这块土地上种植。



  
<br>
<br>
<br>
  
## 魔法生物

  在不匹配的种子和土地之间，可以引入一些魔法生物作为中介，帮助种子生长。
  
  这些魔法生物可以具有特殊的属性或能力，例如火精灵可以帮助火属性种子在冰属性土地上生长，或者冰龙可以帮助冰属性种子在火属性土地上生长。





<br>
<br>
<br>

## 灵活交互

  玩家可以尝试通过调整土地环境、使用特殊道具或施展魔法来适应不同种子的生长需求。例如，火属性种子需要较高的温度，玩家可以使用火魔法在土地上创造火焰环境，提供适宜的温度。



  
<br>
<br>
<br>
  
## 魔法种子融合

  玩家可以尝试将不同属性的种子进行融合，创造出具有多种属性的特殊种子。这些特殊种子可以在多种属性的土地上生长，带来丰富多样的收获和效果。




## 项目后记

一直以来 社会对区块链世界中 我们对于PoW体系下所产生的 **电力能源损失** 产生的批判 始终没有暂停过。

比特币的PoW机制



> 海平面

> > 2022年，全球平均海平面（GMSL）继续上升，达到了有卫星测高记录以来（1993-2022年）的新高。在有卫星记录的第一个十年（1993-2002年，2.27毫米/年）和最近的一个十年（2013-2022年，4.62毫米/年）间，全球平均海平面上升速率翻了一番。


## 游戏捐赠



##  ❤️ 项目贡献者
**永远感谢他们为本项目所作出的贡献！**

[![contrib graph](https://contrib.rocks/image?repo=Web3-Club/Chain-Farm)](https://github.com/Web3-Club/Chain-Farm/graphs/contributors)




## ⚠️ Disclaimer

This project is a work in progress and is not yet ready for public use. It is provided as-is and without warranty of any kind, either express or implied.

The developers of this project are not responsible for any losses or damages that may arise from the use of this project.

Users should be aware of the following risks before using this project:

- The project is still under development and may contain bugs or errors.
- The project is not yet fully secure and may be vulnerable to attack.
- The project is not yet fully compliant with all applicable laws and regulations.
- Users should use this project at their own risk.

### Additional Terms and Conditions

In addition to the above disclaimer, users of this project agree to the following terms and conditions:

- Users are responsible for their own actions when using this project.
- Users agree not to use this project for any illegal or harmful purposes.
- Users agree to indemnify the developers of this project from any losses or damages that may arise from the use of this project.

### Contact Information

If you have any questions or concerns about this project, please contact the developers.

## 参考文献及资料

<div id="refer-anchor-1"></div>
 - [1] [百度学术](http://xueshu.baidu.com/)(https://zh.wikipedia.org/zh-hans/%E9%96%8B%E6%94%BE%E4%B8%96%E7%95%8C)
