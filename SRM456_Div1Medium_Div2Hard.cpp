// http://www.itmedia.co.jp/enterprise/articles/1002/06/news001_2.html

using System;
using System.Collections;
using System.Collections.Generic;
using System.Text;
public class CutSticks {
    public double maxKth(int[] sticks, int C, int K)
    {
        double low = 0;
        double high = 1e9;
        int i,j;
        for (i = 0; i < 100; i++) // 100回は多すぎるのでは
        {
            long count = 0;
            double mid = (low + high) / 2;  //真ん中の数字を調べる midは仮置きの長さ
            long cut = 0;
            for (j = 0; j < sticks.Length; j++)
            {
                long next = (long)(sticks[j] / mid);  //作れる本数
                cut += Math.Max(0, (next - 1)); //切る回数
                count += next; // countは実際作れる本数
            }
            count -= Math.Max(0, cut - C);  //切った回数が多すぎたらその分引く
            if (count >= K) low = mid;  //ここで範囲を半分に狭める
            else high = mid;
        }
        return low; //誤差の制限が甘いので、lowでもhighでもかまわない
    }
}
