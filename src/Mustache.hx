import mustache.*;

class Mustache {
    public static var tags = ["{{", "}}"];

    public static inline function render(template:String, context:Context, ?partials:Partials):String {
        return defaultWriter.render(template, context, partials);
    }

    public static inline function parse(template:String, ?tags:Array<String>):Array<Token> {
        return defaultWriter.parse(template, tags);
    }

    public static inline function clearCache():Void {
        defaultWriter.clearCache();
    }

    static var defaultWriter = new Writer();

    @:allow(mustache.Writer)
    static function getSectionValueKind(value:Dynamic):SectionValueKind {
        if (value == null)
            return KFalsy;

        if (Std.is(value, Bool))
            return if ((value : Bool)) KBasic else KFalsy;

        if (Std.is(value, Float))
            return if ((value : Float) != 0) KBasic else KFalsy;

        var str = Std.instance(value, String);
        if (str != null)
            return if (str.length > 0) KObject(str) else KFalsy;

        var arr = Std.instance(value, Array);
        if (arr != null)
            return if (arr.length > 0) KArray(arr) else  KFalsy;

        if (Reflect.isFunction(value))
            return KFunction(value);

        if (Reflect.isObject(value))
            return KObject(value);

        return KBasic;
    }
}

enum SectionValueKind {
    KFalsy;
    KArray(a:Array<Dynamic>);
    KObject(o:{});
    KBasic;
    KFunction(f:String->(String->Null<String>)->Null<String>);
}
