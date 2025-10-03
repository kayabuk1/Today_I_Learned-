--　1004ごちゃごちゃしてしまったので、こちらに見ないで書くチャレンジしつつ、解答書き直し
- 演習問題４
テーブルHANBAI4……HNO販売番号,DAY売上日,TNO得意先番号
テーブルMEISAI4……MNO明細番号,HNO販売番号,SNO商品番号,SU売上数量
テーブルSYOUHIN4……SNO商品番号,NAME商品名,TANKA単価
テーブルTOKUISAKI4……TNO得意先番号,NAME得意先名,ADR住所

-- ⑴商品A菓子の販売実績、商品名、得意先名、販売日付、売上数を表示(得意先ﾃｰﾌﾞﾙと商品ﾃｰﾌﾞﾙは結合するのはNG)
select 
  (select name from syouhin4 s4 where s4.sno = m4.sno) as　商品名,
  (select tno from tokuisaki4 t4 where t4.tno = (select tno from hanbai4 h4 where h4.hno = m4.hno )) as 得意先名,
  (select day from hanbai4 h4 where h4.hno = m4.hno)as 販売日付,
  su from meisai4 m4 
where (select name from syouhin4 s4 where s4.sno = m4.sno) = 'A菓子'
; 
--別解(暗黙的にINNER JOINと同じに扱われる)
SELECT 
    s4.name, -- SELECT句がとてもシンプルになる
    t4.name,
    h4.day,
    m4.su
FROM
    meisai4 m4, -- 使うテーブルを全て並べる
    hanbai4 h4,
    syouhin4 s4,
    tokuisaki4 t4
WHERE
    -- ここでテーブル間の「相関関係」を全て記述する
    m4.hno = h4.hno
AND m4.sno = s4.sno
AND h4.tno = t4.tno
-- そして、絞り込み条件もここに書く
AND s4.name = 'A菓子';  
