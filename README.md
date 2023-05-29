# 如何构建镜像

```
docker build -t reg.ktjr.com/utils/ocrs-cache:latest --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from reg.ktjr.com/utils/ocrs-cache:latest --target resolver .

docker build -t reg.ktjr.com/utils/ocrs:latest --build-arg BUILDKIT_INLINE_CACHE=1 --cache-from reg.ktjr.com/utils/ocrs-cache:latest --target app .
```


# 请求 OCR 识别接口

## 请求

```
POST /ocrs
Content-Type: application/json

{
    "image_base64": "BASE64_DATA"
}
```

`BASE64_DATA` 为图片的 base64 编码。

## 响应

```
{
  "text": "识别结果"
}
```

