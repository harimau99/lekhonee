/* LekhoneeMain.vala
 *
 * Copyright (C) 2010  Kushal Das <kushal@fedoraproject.org>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.

 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 *
 */

using Gtk;
using WebKit;


public class LekhoneeMain: GLib.Object {
    
    public Builder builder;
    public Window window;
    public TreeView category_list;
    public ScrolledWindow scw;
    public ScrolledWindow scw2;
    public ScrolledWindow scw3;
    public HButtonBox hbuttonbox1;
    public VBox vbox3;
    
    public SourceBuffer blog_txt;
    public SourceView sourceview;
    
    public WebView editor;

    public LekhoneeMain() {
        try {
        builder = new Builder ();
        builder.add_from_file ("new.ui");
        //builder.connect_signals (null);
        window = builder.get_object ("MainWindow") as Window;
        category_list = builder.get_object("category_list") as TreeView;
        
        //For the sourceview
        SourceLanguageManager langm = new SourceLanguageManager();
        SourceLanguage lang = langm.get_language("html");
        scw = builder.get_object("scw") as ScrolledWindow;
        blog_txt = new Gtk.SourceBuffer.with_language(lang);
        sourceview =  new SourceView.with_buffer(blog_txt);
        sourceview.wrap_mode = Gtk.WrapMode.WORD;
        scw.add(sourceview);
        
        //For the Webkit editor
        editor = new WebView();
        editor.set_editable(true);
        editor.load_string("Vala rocks!","text/html","utf-8","preview");
        scw2 = builder.get_object("scw2") as ScrolledWindow;
        scw2.add(editor);
        
        
        //Show/hide correct things
        window.show_all ();
        scw.hide_all();
        hbuttonbox1 = builder.get_object("hbuttonbox1") as HButtonBox;
        hbuttonbox1.hide_all();
        //For the upload file area in the UI
        vbox3 = builder.get_object("vbox3") as VBox;
        vbox3.hide_all();
        //For the entries_list treeview
        scw3 = builder.get_object("scw3") as ScrolledWindow;
        scw3.hide_all();
        
        window.destroy.connect (Gtk.main_quit);
        
        create_connections();

        
        }
        catch (Error e) {
            stderr.printf ("Could not load UI: %s\n", e.message);
        }
    }

    public void show_dialog(MenuItem w){
        var dialog = new AboutDialog();
        dialog.set_name("lekhonee-gnome");
        dialog.set_copyright("(c) 2009-2010 Kushal Das");
        dialog.set_website("http://fedorahosted.org/lekhonee");
        dialog.set_authors({"Kushal Das kushal@fedoraproject.org",null});
        dialog.set_program_name("lekhonee-gnome");
        dialog.run();
        dialog.destroy();
    }

    public void create_connections(){
        var about_activity = builder.get_object("imagemenuitem10") as ImageMenuItem;
        about_activity.activate.connect(show_dialog);
        var bold = builder.get_object("bold") as ToolButton;
        var italic = builder.get_object("italic") as ToolButton;
        var underline = builder.get_object("underline") as ToolButton;
        var insertunorderedlist = builder.get_object("insertunorderedlist") as ToolButton;
        bold.clicked.connect(on_action);
    }

    public void on_action(ToolButton button){
        string name = button.get_name();
        editor.execute_script(@"document.execCommand('$name', false, false);");
    
    }


    public static int main (string[] args) {     
        
        
        Gtk.init (ref args);

 
        LekhoneeMain lh = new LekhoneeMain();

            
        Gtk.main ();
             

        return 0;
    }

}




