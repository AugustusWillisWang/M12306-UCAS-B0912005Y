<?php 
session_start(); 
$username=$_SESSION['username'];
$whether_online=$_SESSION['whether_online'];
$dbconn = pg_connect("host=localhost dbname=test12306 user=dbms password=dbms")
        or die('Could not connect: ' . pg_last_error());
?>

<html>
<head>
    <meta charset="UTF-8">
    <style type="text/css">
        body {background-size: 100%}
        a:link,a:visited{
            text-decoration:none;  /*超链接无下划线*/
            }
        div { padding:18px } 
        img { border:0px; vertical-align:middle; padding:0px; margin:0px; } 
        input, button { font-family:"Arial", "Tahoma", "微软雅黑", "雅黑"; border:0;
        vertical-align:middle; margin:8px; line-height:18px; font-size:18px } 
        .btn{width:136px;height:33px;line-height:18px;font-size:18px;
        background:url("button2.jpg") no-repeat left top;color:#FFF;padding-bottom:4px}
    </style>
    <?php include 'table_style.html' ?>
</head> 
<body>
<?php include 'top.html' ?>
<p style="text-align:center;font-size:40;margin-top:60px">
<?php
    if($_POST["date1"])
        $date1  = strtotime($_POST["date1"]);
    else
        $date1  = strtotime('today');
    $inputdate1 = date("Y-m-d", $date1);
    if($_POST["date2"])
        $date2  = strtotime($_POST["date2"]);
    else
        $date2  = strtotime('tomorrow');
    $inputdate2 = date("Y-m-d", $date2);
    $today = strtotime('today');
    $time = date("Y-m-d", $today);
    if($whether_online != "1")
        echo "请先登录";
    else
    {
        //查询用户身份证
        $query = "
        SELECT P_pid
                FROM Passenger
                WHERE P_uname='$username';
                ";
        $result = pg_query($query) or die('Query failed: ' . pg_last_error());
        $line = pg_fetch_array($result, null, PGSQL_NUM);
        $userid = $line[0];
        //echo $inputdate1.$inputdate2;

        $query = "SELECT
        O_oid, O_order_date, O_tid1,
        scid.ISC_sname as depart_station, 
        scia.ISC_sname as arrive_station, 
        O_price,
        O_valid,
        O_type1
    FROM ID_Station_City as scid, ID_Station_City as scia, Orders  
    WHERE O_start_sid=scid.ISC_sid 
        and O_arrive_sid=scia.ISC_sid
        and O_order_date<=to_date('$inputdate2','YY-MM-DD')
        and O_order_date>=to_date('$inputdate1','YY-MM-DD')
        and O_pid=$userid;
    ";

    $_SESSION['$order_date2'] = $date2;
    $_SESSION['$order_date1'] = $date1;
    $_SESSION['$order_userid'] = $userid;
    $result = pg_query($query) or die('Query failed: ' . pg_last_error());
    $number =0;
    echo "<table>\n";
    echo "\t<tr>\n";
    echo "\t\t<th>订单号</th>";
    echo "\t\t<th>日期</th>";
    echo "\t\t<th>车次</th>";
    echo "\t\t<th>出发站</th>";
    echo "\t\t<th>目的站</th>";
    echo "\t\t<th>价格</th>";
    echo "\t\t<th>座位类型</th>";
    echo "\t</tr>\n";
    while ($line = pg_fetch_array($result, null, PGSQL_NUM)) {
        $number ++;
        if($line[7] =="hardseat")
                $output = "硬座";
            else if($line[7] =="softseat")
                $output = "软座";
            else if($line[7] =="hardbed_top")
                $output = "硬卧上铺";
            else if($line[7] =="hardbed_middle")
                $output = "硬卧中铺";
            else if($line[7] =="hardbed_bottom")
                $output = "硬卧下铺";
            else if($line[7] =="softbed_top")
                $output = "软卧上铺";
            else
                $output = "软卧下铺";
        $test = $line[1];
        //echo"$test[9]";
        echo "\t<tr>\n";
        if($line[6] == 1)
        {
            for($i=0;$i<6;$i++)
            {
                echo "\t\t<td>".$line[$i]."</td>\n";
            }
            echo "\t\t<td>".$output."</td>\n";
            if($time[8] <= $test[8] )
            {
                if($time[9] <= $test[9] )
                {
                    echo "\t\t<td><a href=\"delete_order.php?order_number=$number\">".取消预定."</td>\n";
                    //echo"$line[0]";
                }
            }
            echo "\t\t<td></td>\n";
        }
        else
        {
            for($i=0;$i<6;$i++)
            {
                echo "\t\t<td>".$line[$i]."</td>\n";
            }
            echo "\t\t<td>".$output."</td>\n";
            echo "\t\t<td>已取消</td>\n";
        }
        echo "\t</tr>\n";
    }
    echo "</table>\n";
    // Free resultset
    pg_free_result($result);
    
    // Closing connection
    pg_close($dbconn);

        echo "用户名：";
        echo $username;
    }  
?>
</p>
<p style="text-align:center;font-size:15">
    <a href="myrequest.html">
    <input type="button" class="btn" value="返回" onmouseover="this.style.backgroundPosition='left -36px'"
         onmouseout="this.style.backgroundPosition='left top'" />
    <a>
</p>
</body>
</html>


