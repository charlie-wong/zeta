#!/usr/bin/env node
// SPDX-License-Identifier: GPL-3.0-or-later OR Apache-2.0 OR MIT
// SPDX-FileCopyrightText: 2024 Charles Wong <charlie-wong@outlook.com>
// Repository: https://github.com/charlie-wong/zeta

// charCodeAt()　返回指定字符的 Unicode 编码
// 返回值的范围是 x0 ~ xFFFF，BMP平面编码，即UTF-16编码

if(process.argv.length != 3) {
  // node unicode-codepoint.js ABC
  console.log("Unicode 字符码值 unicode-codepoint.js ⫷☡⫸");
  process.exit(0);
}

const args = process.argv[2];
console.log("Glyph\tDEC\tHEX\tBIN");

for(let i=0; i<args.length; i++) {
  let char = args[i];
  let dec = char.charCodeAt(0).toString(10);
  let hex = char.charCodeAt(0).toString(16);
  let bin = char.charCodeAt(0).toString(2);
  console.log(char + "\t" + dec + "\tU+" + hex + "\t" + bin);
}

// 彻底搞懂Unicode编码问题
// https://wangwl.net/static/pages/unicode.html

// BOM(Byte Order Mark)
// UTF-8不必手动添加BOM，保持原样即可，除非有必要时再添加
// UTF-16和UTF-32则需要设置正确的BOM，因为文本解码推测可能失败
// * UTF-8        EF BB BF
// * UTF-16(BE)   FE FF
// * UTF-16(LE)   FF FE
// * UTF-32(BE)   00 00 FE FF
// * UTF-32(LE)   FF FE 00 00

// 半角(halfwidth)和全角(fullwidth)
// 半角/全角对应的是字符显示，对于定宽的字体，全角字符占用的宽度是半角字符的两倍
// 可以简单的认为码位大于128的都是全角字符，即 ASCII 字符是半角

// HTML转义或HTML实体引用
// 1. 数字字符引用(numeric character reference)
//    十进制   &#nnnn;
//    十六进制 &#xhhhh;  x必须小写．hhhh大小写可混用
// 2. 字符实体引用(character entity reference)
//    语法  &name;
//    name 必须小写，例如 &lt; 表示小于号 <
//    目前HTML5中支持的命名实体
//    https://html.spec.whatwg.org/multipage/named-characters.html

// Unicode码位(Code Point)范围: x0 到 x10FFFF, 共 2^21 个码位
// 0x10 的十进制是17，所以共分为 17 份，每份为一个码值平面(Plane)
// 每个码值平面包含 2^16 个码位，即范围: x0 到 xFFFF
//
// UTF-32，定长编码
//  使用4字节表示一个 Unicode 字符，直接使用码值，前边空余部分补零
// UTF-16，变长编码
//  - 码位小于等于 xFFFF 的字符，使用2字节存储，直接使用码值
//  - 码位大于 xFFFF 的字符，使用4字节存储
//    码值二进制拆分为两部分，前11位 hhhhhhhhhhh 和后10位 xxxxxxxxxx
//    * 前11位
//      hhhhhhhhhhh 的前５位表示平面，为区分将其表示为 ppppp hhhhhh
//      由于前５位 ppppp 的有效值是 x0 ~ x10, 减１压缩到４位，表示为 wwww
//      最终前11位可以表示为 wwww hhhhhh，即处理后前11位可以用10位表示
//    * 构建4字节编码
//      处理后的前11位前导 110110，构成4字节编码的高位双字节，即 110110 wwww hhhhhh
//      原始码值的低10位前导 110111，构成4字节编码的低位双字节，即 110111 xxxxxxxxxx
//      最终编码值 110110 wwww hhhhhh, 110111 xxxxxxxxxx
// UTF-8，变长编码
//  - 码位小于等于 x007F 使用1字节
//    0xxx xxxx
//  - 码位小于等于 x07FF，大于 x007F 的使用2字节
//    110x xxxx, 10xx xxxx
//  - 码位小于等于 xFFFF，大于 x07FF 的使用3字节
//    1110 xxxx, 10xx xxxx, 10xx xxxx
//  - 码位大于 xFFFF 的字符，使用4/5/6字节存储
//    1111 0xxx, 10xx xxxx, 10xx xxxx, 10xx xxxx
//    1111 10xx, 10xx xxxx, 10xx xxxx, 10xx xxxx, 10xx xxxx
//    1111 110x, 10xx xxxx, 10xx xxxx, 10xx xxxx, 10xx xxxx, 10xx xxxx
