# GVM

Un nuevo proyecto Flutter.

## Comenzando

Este proyecto es un punto de partida para una aplicación Flutter que sigue el
[tutorial de gestión simple del estado de la aplicación](https://flutter.dev/to/state-management-sample).

Para obtener ayuda para comenzar con el desarrollo de Flutter, consulte la
[documentación en línea](https://docs.flutter.dev), que ofrece tutoriales,
ejemplos, orientación sobre desarrollo móvil y una referencia completa de la API.

## Activos

El directorio `assets` alberga imágenes, fuentes y cualquier otro archivo que desee
incluir con su aplicación.

El directorio `assets/images` contiene [imágenes conscientes de la resolución](https://flutter.dev/to/resolution-aware-images).

## Localización

Este proyecto genera mensajes localizados basados en archivos arb encontrados en
el directorio `lib/src/localization`.

Para admitir idiomas adicionales, visite el tutorial sobre
[Internacionalización de aplicaciones Flutter](https://flutter.dev/to/internationalization).

## Enlaces Profundos (Deep Links)

Esta aplicación admite enlaces profundos con el esquema `gvm://`. Los enlaces profundos se manejan de la siguiente manera:

1. Esquema URL: `gvm://`
2. Host: `kildall.ar`
3. Ruta: Cualquier ruta válida en la aplicación (por ejemplo, `/login`)

### Ejemplo de Enlace Profundo:

```bash
gvm://kildall.ar/login
```

### Configuración de Android:
El archivo `AndroidManifest.xml` está configurado para manejar estos enlaces profundos con un intent-filter específico:

```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="gvm" android:host="kildall.ar" android:pathPattern=".*" />
</intent-filter>
```