--演習問題４
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所
-- ⑴商品A菓子の販売実績、商品名、得意先名、販売日付、売上数を表示(得意先ﾃｰﾌﾞﾙと商品ﾃｰﾌﾞﾙは結合するのはNG)
select
      (select name from syouhin4 where syouhin4.sno = meisai4.sno)as 商品名,
      (select name from tokuisaki4 where tokuisaki4.tno = 
          (select hanbai4.tno from hanbai4 where hanbai4.hno = meisai4.hno))as 得意先名,
      (select day from hanbai4 where hanbai4.hno = meisai4.hno)as 販売日付,
      su as 売上数
from meisai4
where (select name from syouhin4 where syouhin4.sno = meisai4.sno) = 'A菓子'
order by day DESC;

-- ⑵最新の船橋商会の売上日の販売実績
-- 得意先、販売番号、売上日、商品名、単価、売上額（販売番号、商品番号の昇順で表示）を表示せよ。
select 
    (select t4.name from tokuisaki4 t4 where t4.tno = 
        (select h4.tno from hanbai4 h4 where h4.hno = m4.hno))as 得意先名,
    m4.hno as 販売番号,
    (select h4.day from hanbai4 h4 where h4.hno = m4.hno)as 売上日,
    (select s4.name from syouhin4 s4 where s4.sno = m4.sno)as 商品名,
    (select s4.tanka from syouhin4 s4 where s4.sno = m4.sno)as 単価,
    m4.su * (select s4.tanka from syouhin4 s4 where s4.sno =m4.sno)as 売上額
from meisai4 m4
where (SELECT t4.name FROM tokuisaki4 t4 WHERE t4.tno =
        (SELECT h4.tno FROM hanbai4 h4 WHERE h4.hno = m4.hno)
      ) = '船橋商会'
     //ANDの条件だけでは、船橋商会の「最新日と」同じ行と言う条件になり、たまたま同じ日の別の商会が選ばれてしまう可能性が
  あるので、きちんとname='船橋商会'と書く。船橋商会の～という意味で使われているからと言って船橋商会のデータだけになる訳
  ではない。きちんと書く。
AND  (select h4.day from hanbai h4 where h4.hno = m4.hno) 
  　      =　(select MAX(h4.day)from hanbai4 h4 where h4.tno
                IN (select t4.tno from tokuisaki4 where t4.name = '船橋商会'))
    //whereの左側のｻﾌﾞｸｴﾘの役割はmeisai4の1行1行の日付を調べること(だからinner joinで関連付けられた主キーを辿って
      一つのテーブルにする様に、サブクエリで相関関係を持たせている。もし関連づけしなかったらただ販売テーブルの日付を
      返すだけで、その日付が明細テーブルの各行とどう関連づいているのかが分からなくなってしまう)
    //右側のサブクエリの役割は「船橋商会の最新日」というただ一つの固定された基準値を計算すること。
      これは明細テーブルの各データと関連付けなくても何のデータか明らか。だから非相関サブクエリで別のテーブルからデータを
      引っ張ってきたままで良い。
  order by m4.hno,m4.sno ASC;

-- ⑶１回も売れていない商品名
select name from syouhin4 where NOT EXISTS
      (select 1 from meisai4 where meisai4.sno = syouhin.sno);
/*この1は特に意味を持っていま。せん。TRUEという意味でもなく、meisai4テーブルから探してきた値でもありません。
SELECT *よりも、データベースが列情報を確認しなくて済むので、ほんの僅かに効率が良い
1はタイプ数が少なく、意味のない値であることが誰の目にも明らかなため、慣習としてよく使われる
というだけの理由*/

-- ⑷商品の単価が高い順に3個表示する。商品名、単価、順位を表示すること。
select t2.name, t2.tanka, t2."順位"
from  (select t1.name, t1.tanka, rownum as "順位"
       from  (select name, tanka from syouhin4 order by tanka DESC) t1) t2
where t2."順位" <= 3;
なんでt2.t1.tankaみたいに書かなくて良いのだろうか？
⇒外側のクエリからは（）の外に付けたインラインビューのエイリアスt2は分かるがサブクエリがインラインビューを作るために
　中で使ったエイリアスt1は見えないから。

-- ⑸売上合計額が船橋商会よりも低く、鎌ヶ谷商会よりも高い得意先売上情報を表示　
--得意先番号、得意先、売上合計金額を表示
select t4.tno as 得意先番号, t4.name as　得意先名, 
      (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno)
       from meisai4 m4 
       where m4.hno = ANY (select h4.hno from hanbai4 h4 where h4.tno = t4.tno)))as 売上合計金額
　　　　サブクエリでmeisai4を主役にした非相関サブクエリで売上合計額をセレクト句に並べる。
      　where句の条件で相関サブクエリを使って得意先テーブルと関連付ける。複数かえって来るのでINか＝ANY
from tokuisaki4 t4 
where 
      (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno)
       from meisai4 m4
       where m4.hno =ANY(select h4.hno from hanbai4 h4 where h4.tno = t4.tno)))
     < (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno)
        from meisai4 m4 
        where m4.hno =ANY(select h4.hno from hanbai4 h4 
                          where h4.tno =(select t4.tno from tokuisaki4 t4 where name = '船橋商会'))))
AND
       (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno)
       from meisai4 m4
       where m4.hno =ANY(select h4.hno from hanbai4 h4 where h4.tno = t4.tno)))
     >  (select sum(m4.su *(select s4.tanka from syouhin4 s4 where s4.sno = m4.sno)
        from meisai4 m4 
        where m4.hno =ANY(select h4.hno from hanbai4 h4 
                          where h4.tno =(select t4.tno from tokuisaki4 t4 where name = '鎌ヶ谷商会'))))
/*問題で合計の様な集計関数を使うものが問われるとgroup byを真っ先に考えてしまうが、
group byを使うためにはfrom句でJOINを使ってテーブル結合することが必須。
group byが使えるのは、from句ですべての材料(テーブル)が並べ終わった後。
材料として並べられていないテーブルにgoroup byという処理をすることは出来ない。
サブクエリのみで書くとなると、from句で相関して広げることが出来ないので、
主役のテーブルを一つ決めて、select句、where句で都度相関させていく、
条件を設定する場合は、select句で結果を並べるように、相関させた条件をANDで並べる。*/

--⑹千葉商会への売上について、商品ごとの売り上げ合計数が習志野・鎌ヶ谷商会の売上合計数を超えた商品
select s4.name as　商品名,
      (select coalesce(sum(m4.su),0)from meisai4 m4 
       where m4.sno = s4.sno
       AND m4.hno IN (select h4.hno from hanbai4 h4 where h4.tno 
                        =(select t4.tno from tokuisaki4 t4 where t4.name = '千葉商会')))as 千葉商会売上数合計
from syouhin4 s4
where (select coalesce(sum(m4.su),0)from meisai4 m4 where m4.sno =s4.sno AND m4.hno IN
        (select h4.hno from hanbai4 h4 where h4.tno =(select t4.tno from tokuisaki4 t4 where t4.name ='千葉商会')))
       > (select coalesce(sum(m4.su),0)from meisai4 m4 where m4.sno =s4.sno AND m4.hno IN
        (select h4.hno from hanbai4 h4 where h4.tno =(select t4.tno from tokuisaki4 t4 where t4.name ='習志野商会')))
AND    (select coalesce(sum(m4.su),0)from meisai4 m4 where m4.sno =s4.sno AND m4.hno IN
        (select h4.hno from hanbai4 h4 where h4.tno =(select t4.tno from tokuisaki4 t4 where t4.name ='千葉商会')))
　     >(select coalesce(sum(m4.su),0)from meisai4 m4 where m4.sno =s4.sno AND m4.hno IN
        (select h4.hno from hanbai4 h4 where h4.tno =(select t4.tno from tokuisaki4 t4 where t4.name ='鎌ヶ谷商会')))
;//SELECT句で名付けたエイリアスはFROM句で名付けたエイリアスと違って最後に処理されるので、
//WHERE句で千葉商会売上数合計の様なエイリアスを使うことは出来ない。
//つまり同じサブクエリを繰り返えすしかない。








