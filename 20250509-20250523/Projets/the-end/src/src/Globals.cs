
using System.Runtime.CompilerServices;
using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Content;

public static class Globals
{
    public static GraphicsDeviceManager Graphics;
    public static ContentManager Content;
    public static Size ScreenSize;
    public static Size MapTileSize;
    public static float TileScale = 1;

    public static void Init(GraphicsDeviceManager graphics, ContentManager Content, Size screenSize)
    {
        Graphics = graphics;
        Globals.Content = Content;
        ScreenSize = screenSize;
    }
}