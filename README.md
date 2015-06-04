# 簡易アップローダー Filezo
Railsで書かれた簡易アップローダーです。

個々のファイルにハッシュのURLが付いてて便利

![chinpo](http://i.gyazo.com/e5f59924a25644fbe974ffe68bf07905.png)

![chinchin](http://i.gyazo.com/954b329a8f1adfab2f6b238cfb5f938d.png)

## API
あとGyazo風のAPIが付いてて、アプリからでも簡単にアップロードできます。

`/upload.txt`に`filedata`フィールドにファイルをつっこんで`post`すると、アップロード先URLが返ってきます。

### C#の例
    private string UploadDocument(string filePath, string originalName)
    {
        string UPLOAD_URL = "http://hidesys.net:3000/upload.txt";
        string receivedUrl = "";
    
        int tryCount = 0;
        bool succeeded = false;
        bool useProxyRegistryValue = GetRegistrySettingBool("UseIEConfig", true);
        bool useProxy = useProxyRegistryValue;
        try
        {
            while (tryCount++ < 3 && !succeeded)
            {
                try
                {
                    System.Text.Encoding enc = System.Text.Encoding.GetEncoding("UTF-8");
                    System.Net.HttpWebRequest req = (System.Net.HttpWebRequest)System.Net.HttpWebRequest.Create(UPLOAD_URL);
                    req.UserAgent = "FilezoClient/1.0";
                    req.Proxy = useProxy ? System.Net.WebRequest.GetSystemWebProxy() : null;
                    req.AutomaticDecompression = System.Net.DecompressionMethods.GZip;
                    req.Method = "POST";
                    string boundary = "BOUNDARYchinpoBOUNDARY" + System.Environment.TickCount.ToString();
                    byte[] startData = enc.GetBytes(
                        "--" + boundary + "\r\n" +
                        "Content-Disposition: form-data; name=\"filedata\"; filename=\"" +
                        originalName + "\"\r\n" +
                        "Content-Type: application/octet-stream\r\n" +
                        "Content-Transfer-Encoding: binary\r\n\r\n"
                        );
                    byte[] endData = enc.GetBytes("\r\n--" + boundary + "--\r\n");
                    using (FileStream fs = new FileStream(filePath, FileMode.Open, FileAccess.Read))
                    {
                        req.ContentLength = startData.Length + fs.Length + endData.Length;
                        req.ContentType = "multipart/form-data; boundary=" + boundary;
                        using (Stream reqStream = req.GetRequestStream())
                        {
                            reqStream.Write(startData, 0, startData.Length);
                            int bufferSize = 0x1024;
                            byte[] readData = new byte[bufferSize];
                            int readSize = 0;
    
                            while (true)
                            {
                                readSize = fs.Read(readData, 0, readData.Length);
                                if (readSize == 0) { break; }
                                reqStream.Write(readData, 0, readSize);
                            }
                            reqStream.Write(endData, 0, endData.Length);
                            //アップロード完了。
    
                            System.Net.HttpWebResponse res = (System.Net.HttpWebResponse)req.GetResponse();
                            
                            using (Stream resStream = res.GetResponseStream())
                            using (StreamReader sr = new StreamReader(resStream, enc))
                            {
                                receivedUrl = sr.ReadToEnd();
                            }
                        }
                    }
    
                    //Proxy使用の可否が変更された場合は、レジストリに書き込む
                    if (useProxy != useProxyRegistryValue)
                    {
                        SetResistrySettingBool("UseIEConfig", useProxy);
                    }
                    succeeded = true;
                }
                catch (System.Net.WebException)
                {
                    //ダメだったらプロキシ設定をON/OFFしてみて試す
                    useProxy = !useProxy;
                }
                catch (System.Configuration.ConfigurationException)
                {
                    //Proxyの設定が壊れてる感じなので、プロキシを使うのをやめる
                    useProxy = false;
                }
            }
        }
        catch (Exception ex)
        {
            //ShowErrorDialog(ex);
            throw ex;
        }
    
        return receivedUrl;
    }

