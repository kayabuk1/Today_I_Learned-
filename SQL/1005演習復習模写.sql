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


