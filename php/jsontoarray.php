<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	<meta http-equiv="Content-Style-Type" content="text/css" />
	<meta http-equiv="Content-Script-Type" content="text/javascript" />
	<title>JSON → Array 変換</title>

	<style type="text/css">
		.form-control {
			width: 640px;
		}
			.form-control textarea {
				width: 600px;
				height: 16em;
				padding: 5px;
			}
		pre {
			background-color: #F0F0F0;
			padding: 5px 10px;
		}
	</style>

</head>

<body>
	<!-- rawurldecode → JSON → Array 変換 -->

	<h2>rawurldecode → JSON → Array 変換</h2>
	<div class="form-control">
		<form method="POST">
			<textarea name="jsondata_escaped" placeholder="JSON (escaped) データを貼り付ける" /><?php if ( false === empty( $_REQUEST['jsondata_escaped'] ) ) {
				echo $_REQUEST['jsondata_escaped'];
			} ?></textarea>
			<input type="submit" value="送信" />
		</form>
	</div>

	<?php if ( false === empty( $_REQUEST['jsondata_escaped'] ) ) { ?>
		<pre><?php var_dump( json_decode( rawurldecode( $_REQUEST['jsondata_escaped'] ), true ) ); ?></pre>
	<?php } ?>

	<!-- JSON → Array 変換 -->

	<h2>JSON → Array 変換</h2>
	<div class="form-control">
		<form method="POST">
			<textarea name="jsondata" placeholder="JSON データを貼り付ける" /><?php if ( false === empty( $_REQUEST['jsondata'] ) ) {
				echo $_REQUEST['jsondata'];
			} ?></textarea>
			<input type="submit" value="送信" />
		</form>
	</div>

	<?php if ( false === empty( $_REQUEST['jsondata'] ) ) { ?>
		<pre><?php var_dump( json_decode( $_REQUEST['jsondata'], true ) ); ?></pre>
	<?php } ?>

	<!-- プレーンテキスト -> rawurlencode() 変換 -->

	<h2>プレーンテキスト -> rawurlencode() 変換</h2>
	<div class="form-control">
		<form method="POST">
			<textarea name="data_for_rawurlencode" placeholder="テキストデータを貼り付ける" /><?php if ( false === empty( $_REQUEST['data_for_rawurlencode'] ) ) {
				echo $_REQUEST['data_for_rawurlencode'];
			} ?></textarea>
			<input type="submit" value="送信" />
		</form>
	</div>

	<?php if ( false === empty( $_REQUEST['data_for_rawurlencode'] ) ) { ?>
		<pre><?php var_dump( rawurlencode( $_REQUEST['data_for_rawurlencode'] ) ); ?></pre>
	<?php } ?>

	<!-- rawurlencode() -> rawurldecode() 変換 -->

	<h2>rawurlencode() -> rawurldecode() 変換</h2>
	<div class="form-control">
		<form method="POST">
			<textarea name="data_for_rawurldecode" placeholder="rawurlencode() でエンコードされたデータを貼り付ける" /><?php if ( false === empty( $_REQUEST['data_for_rawurldecode'] ) ) {
				echo $_REQUEST['data_for_rawurldecode'];
			} ?></textarea>
			<input type="submit" value="送信" />
		</form>
	</div>

	<?php if ( false === empty( $_REQUEST['data_for_rawurldecode'] ) ) { ?>
		<pre><?php var_dump( rawurldecode( $_REQUEST['data_for_rawurldecode'] ) ); ?></pre>
	<?php } ?>

</body>
</html>
