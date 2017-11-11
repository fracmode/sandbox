<?php

class Param
{
    private static $_param_file_name = './param.json';

    private static $_param_data;

    public static function get_param_file_path()
    {
        return sys_get_temp_dir() . '/' . static::$_param_file_name;
    }

    public static function load()
    {
        if (! file_exists(static::get_param_file_path())) {
            return [];
        }
        $content = file_get_contents(static::get_param_file_path());
        static::$_param_data = json_decode($content, true);
    }

    public static function save()
    {
        if (empty(static::$_param_data)) {
            return false;
        }
        file_put_contents(static::get_param_file_path(), json_encode(static::$_param_data));
        return true;
    }

    public static function get($key)
    {
        if (! isset(static::$_param_data[$key])) {
            return null;
        }
        return static::$_param_data[$key];
    }

    public static function set($key, $value)
    {
        static::$_param_data[$key] = $value;
    }

    public static function get_all()
    {
        return static::$_param_data;
    }
}

class Main
{
    private static $_target_domain = 'https://gamewith.jp/';
    private static $_login_page_path = 'user/login/';
    private static $_feed_home_path = 'home';
    private static $_feed_post_path = 'post/post/create/';

    private static $_auth_data = [
        'username' => '********@********',
        'password' => '********'
    ];

    public function run($argv)
    {
        date_default_timezone_set('Asia/Tokyo');

        // echo var_export($argv, true);

        // \Param::load();

        // $logged_in_cookie = \Param::get('logged_in_cookie');
        $logged_in_cookie = null; // どうせ csrf_token を取りに行く必要があるので、普通にログインしに行く
        if (empty($logged_in_cookie)) {
            $logged_in_cookie = $this->_get_logged_in_cookie();
            // \Param::set('logged_in_cookie', $logged_in_cookie);
            // \Param::save();
        }
        // $logged_in_cookie = $this->_renew_cookie_for_post($logged_in_cookie);

        $this->_post_feed_kiritori($logged_in_cookie);

        echo "done.\n";
    }

    private function _post_feed_kiritori($logged_in_cookie)
    {
        $date_str = date('m/d H:00');
        echo "post kiritori feed (${date_str})...\n";

        $post_data = [
            'mojolicious_csrf_token' => $this->_get_value_from_cookie($logged_in_cookie, 'mojolicious_csrf_token'),
            'body' => "✄————${date_str}————✄"
        ];

        echo "  csrf token: ${post_data['mojolicious_csrf_token']}\n";

        $url = static::$_target_domain . static::$_feed_post_path;
        return $this->_post_request($url, $post_data, $logged_in_cookie, true);
    }

    private function _post_request($url, $post_data = [], $cookie = '', $dump_html = false)
    {
        echo "(POST request)\n";
        $tmp_path = tempnam(sys_get_temp_dir(), "CKI");
        if (! empty($cookie)) {
            file_put_contents($tmp_path, $cookie);
        }

        $ch = curl_init();

        curl_setopt($ch, CURLOPT_URL, $url);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
        curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
        curl_setopt($ch, CURLOPT_MAXREDIRS, 10);
        curl_setopt($ch, CURLOPT_AUTOREFERER, true);

        curl_setopt($ch, CURLOPT_COOKIEFILE, $tmp_path);
        curl_setopt($ch, CURLOPT_COOKIEJAR, $tmp_path);

        curl_setopt($ch, CURLOPT_POST, true);
        if (! empty($post_data)) {
            curl_setopt($ch, CURLOPT_POSTFIELDS, http_build_query($post_data));
        }

        $html = curl_exec($ch);
        if ($dump_html) {
            // $info = curl_getinfo($ch);
            // var_dump($info);
            // var_dump($html);
        }
        curl_close($ch);

        $cookie_str = file_get_contents($tmp_path);
        unlink($tmp_path);

        return $cookie_str;
    }

    private function _get_value_from_cookie($cookie_str, $key)
    {
        $pattern = "/\t${key}\t(.+)/";
        preg_match($pattern, $cookie_str, $match);
        if (! isset($match[1])) {
            return null;
        }
        return $match[1];
    }

    private function _get_logged_in_cookie()
    {
        echo "get logged in cookie...\n";

        $url = static::$_target_domain . static::$_login_page_path;

        $cookie = $this->_post_request($url);

        $post_data = static::$_auth_data;
        $post_data['mojolicious_csrf_token'] = $this->_get_value_from_cookie($cookie, 'mojolicious_csrf_token');

        echo "  csrf token: ${post_data['mojolicious_csrf_token']}\n";

        return $this->_post_request($url, $post_data, $cookie);
    }

    private function _renew_cookie_for_post($logged_in_cookie)
    {
        // var_dump($logged_in_cookie);
        echo "renew cookie for post...\n";

        $url = static::$_target_domain . static::$_feed_home_path;
        $logged_in_cookie = $this->_get_request($url, $logged_in_cookie);
        // var_dump($logged_in_cookie);
        return $logged_in_cookie;
    }
}

$main = new Main();
$main->run($argv);
