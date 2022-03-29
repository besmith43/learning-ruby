/*
 *
 * by Noritsugu Nakamura
 * from 2001.04.20
 *
 * modified by Eric Sperano
 * from 2012.02.27
 *
 * Now using:
 * - RARRAY_LEN() instead of RARRAY()->len
 * - RARRAY_PTR() instead of RARRAY()->ptr
 * - StringValuePtr instead of STR2CSTR
 *
 * Also added some missing cast that triggered annoying warnings.
 *
 */

#include <ruby.h>
#include <rubyio.h>
#include <newt.h>

static VALUE mNewt;
static VALUE mScreen;
static VALUE cWidget;
static VALUE cForm;
static VALUE cLabel;
static VALUE cCompactButton;
static VALUE cButton;
static VALUE cCheckbox;
static VALUE cRadioButton;

static VALUE cListbox;
static VALUE cCheckboxTree;
static VALUE cCheckboxTreeMulti;
static VALUE cTextbox;
static VALUE cTextboxReflowed;
static VALUE cEntry;
static VALUE cScale;
static VALUE cGrid;

static ID rb_call_id;
static VALUE rb_ext_Widget_CALLBACK_HASH;

typedef struct snackWidget_s snackWidget;

struct callbackStruct {
  VALUE *cb, *data;
};

struct snackWidget_s {
  newtComponent co;
  char achar;
  void * apointer;
  int anint;
  struct callbackStruct scs;
};


/* 
 * ReflowText 
 *
 */
static VALUE
rb_ext_ReflowText(VALUE self, VALUE text, VALUE width, VALUE flexDown, VALUE flexUp)
{
  int actualWidth, actualHeight;
  char *p;
  VALUE ary = rb_ary_new2(3);

  p = newtReflowText(StringValuePtr(text), NUM2INT(width), NUM2INT(flexDown), NUM2INT(flexUp),
					 &actualWidth, &actualHeight);

  rb_ary_push(ary, rb_str_new2(p));
  rb_ary_push(ary, INT2NUM(actualWidth));
  rb_ary_push(ary, INT2NUM(actualHeight));
  return ary;
}

/*
 * Screen_new
 *
 */
static VALUE
rb_ext_Screen_new()
{
  newtInit();
  newtCls();

  return Qnil;
}

/*
 * Screen_Init
 *
 */
static VALUE
rb_ext_Screen_Init()
{
  newtInit();
  return Qnil;
}

/*
 * Screen_Cls
 *
 */
static VALUE
rb_ext_Screen_Cls()
{
  newtCls();
  return Qnil;
}

/*
 * Screen_Finished
 *
 */
static VALUE
rb_ext_Screen_Finished()
{
  newtFinished();

  return Qnil;
}

/*
 * Screen_WaitForKey
 *
 */
static VALUE
rb_ext_Screen_WaitForKey()
{
  newtWaitForKey();

  return Qnil;
}

/*
 * Screen_ClearKeyBuffer
 *
 */
static VALUE
rb_ext_Screen_ClearKeyBuffer()
{
  newtClearKeyBuffer();

  return Qnil;
}

/*
 * Screen_OpenWindow
 *
 */
static VALUE
rb_ext_Screen_OpenWindow(VALUE self, VALUE left, VALUE top,
						 VALUE width, VALUE height, VALUE title)
{
  return INT2NUM(newtOpenWindow(NUM2INT(left), NUM2INT(top),
								NUM2INT(width), NUM2INT(height), StringValuePtr(title)));
}

/*
 * Screen_CenteredWindow
 *
 */
static VALUE
rb_ext_Screen_CenteredWindow(VALUE self, VALUE width, VALUE height, VALUE title)
{
  return INT2NUM(newtCenteredWindow(NUM2INT(width), NUM2INT(height), StringValuePtr(title)));
}

/*
 * Screen_PopWindow
 *
 */
static VALUE
rb_ext_Screen_PopWindow(VALUE self)
{
  newtPopWindow();
  return Qnil;
}


/*
 * Screen_Resume
 *
 */
static VALUE
rb_ext_Screen_Resume()
{
  newtResume();

  return Qnil;
}

/*
 * Screen_Suspend
 *
 */
static VALUE
rb_ext_Screen_Suspend()
{
  newtSuspend();

  return Qnil;
}

/*
 * Screen_Refresh
 *
 */
static VALUE
rb_ext_Screen_Refresh()
{
  newtRefresh();

  return Qnil;
}

/*
 * Screen_DrawRootText
 *
 */
static VALUE
rb_ext_Screen_DrawRootText(VALUE self, VALUE col, VALUE row, VALUE text)
{

  newtDrawRootText(NUM2INT(col), NUM2INT(row), StringValuePtr(text));
  return Qnil;
}

/*
 * Screen_PushHelpLine
 *
 */
static VALUE
rb_ext_Screen_PushHelpLine(VALUE self, VALUE text)
{
  newtPushHelpLine(StringValuePtr(text));

  return Qnil;
}

/*
 * Screen_RedrawHelpLine
 *
 */
static VALUE
rb_ext_Screen_RedrawHelpLine(VALUE self)
{
  newtRedrawHelpLine();

  return Qnil;
}

/*
 * Screen_PopHelpLine
 *
 */
static VALUE
rb_ext_Screen_PopHelpLine(VALUE self)
{
  newtPopHelpLine();

  return Qnil;
}

/*
 * Screen_Bell
 *
 */
static VALUE
rb_ext_Screen_Bell(VALUE self)
{
  newtBell();

  return Qnil;
}

/*
 * Screen_Size
 *
 */
static VALUE
rb_ext_Screen_Size(VALUE self)
{
  int cols, rows;
  VALUE ary = rb_ary_new2(2);

  newtGetScreenSize(&cols, &rows);
  rb_ary_push(ary, INT2NUM(cols));
  rb_ary_push(ary, INT2NUM(rows));

  return ary;
}

/*
 * Screen_WinMessage
 *
 */
static VALUE
rb_ext_Screen_WinMessage(VALUE self, VALUE args)
{
  if (RARRAY_LEN(args) < 3) {
	rb_raise(rb_eArgError, "3 arguments required");
  } else {
	
	newtWinMessage(StringValuePtr(RARRAY_PTR(args)[0]), StringValuePtr(RARRAY_PTR(args)[1]), StringValuePtr(RARRAY_PTR(args)[2]));
  }

  return Qnil;
}

/*
 * Screen_WinChoice
 *
 */
static VALUE
rb_ext_Screen_WinChoice(VALUE self, VALUE args)
{
  if (RARRAY_LEN(args) < 4) {
	rb_raise(rb_eArgError, "4 arguments required");
  } else {
	
	newtWinChoice(StringValuePtr(RARRAY_PTR(args)[0]), StringValuePtr(RARRAY_PTR(args)[1]),
				   StringValuePtr(RARRAY_PTR(args)[2]), StringValuePtr(RARRAY_PTR(args)[3]));
  }

  return Qnil;
}

/*
 * Screen_WinMenu
 *
 */
static VALUE
rb_ext_Screen_WinMenu(VALUE self, VALUE args)
{
  long len;
  int i, listItem;
  char **cptr;

  len = RARRAY_LEN(args);
  if (len == 8) {
	Check_Type(RARRAY_PTR(args)[6], T_ARRAY);

	len = RARRAY_LEN(RARRAY_PTR(args)[6]);
	cptr = ALLOCA_N(char*, len + 1);
	for (i = 0; i < len; i++) {
	  Check_Type(RARRAY_PTR(RARRAY_PTR(args)[6])[i], T_STRING);
	  cptr[i] = StringValuePtr(RARRAY_PTR(RARRAY_PTR(args)[6])[i]);
	}
	cptr[len] = NULL;
	
	newtWinMenu(StringValuePtr(RARRAY_PTR(args)[0]), StringValuePtr(RARRAY_PTR(args)[1]),
				NUM2INT(RARRAY_PTR(args)[2]),
				NUM2INT(RARRAY_PTR(args)[3]), NUM2INT(RARRAY_PTR(args)[4]),
				NUM2INT(RARRAY_PTR(args)[5]),
				cptr, &listItem, StringValuePtr(RARRAY_PTR(args)[7]), NULL);
	return INT2NUM(listItem);
  }	else if (len == 9) {
	Check_Type(RARRAY_PTR(args)[6], T_ARRAY);

	len = RARRAY_LEN(RARRAY_PTR(args)[6]);
	cptr = ALLOCA_N(char*, len + 1);
	for (i = 0; i < len; i++) {
	  Check_Type(RARRAY_PTR(RARRAY_PTR(args)[6])[i], T_STRING);
	  cptr[i] = StringValuePtr(RARRAY_PTR(RARRAY_PTR(args)[6])[i]);
	}
	cptr[len] = NULL;
	
	newtWinMenu(StringValuePtr(RARRAY_PTR(args)[0]), StringValuePtr(RARRAY_PTR(args)[1]),
				NUM2INT(RARRAY_PTR(args)[2]),
				NUM2INT(RARRAY_PTR(args)[3]), NUM2INT(RARRAY_PTR(args)[4]),
				NUM2INT(RARRAY_PTR(args)[5]),
				cptr, &listItem, StringValuePtr(RARRAY_PTR(args)[7]), StringValuePtr(RARRAY_PTR(args)[8]), NULL);
	return INT2NUM(listItem);
  } else {
	rb_raise(rb_eArgError, "8 or 9 arguments required");
  }

  return Qnil;
}

/*
 * Screen_WinEntries
 *
 */
static VALUE
rb_ext_Screen_WinEntries(VALUE self, VALUE args)
{
  long len;
  int i;
  struct newtWinEntry *items;
  char * entries[10];
  VALUE ary;

  memset(entries, 0, sizeof(entries));
  ary = rb_ary_new();

  len = RARRAY_LEN(args);
  if (len == 8) {
	Check_Type(RARRAY_PTR(args)[6], T_ARRAY);

	len = RARRAY_LEN(RARRAY_PTR(args)[6]);
	if (len > 8) rb_raise(rb_eArgError, "8 or less arguments required");
	items = ALLOCA_N(struct newtWinEntry, len + 1);
	for (i = 0; i < len; i++) {
	  Check_Type(RARRAY_PTR(RARRAY_PTR(args)[6])[i], T_STRING);
	  items[i].text = StringValuePtr(RARRAY_PTR(RARRAY_PTR(args)[6])[i]);
	  items[i].value = entries + i;
	  items[i].flags = 0;
	}
	items[len].text = NULL;
	items[len].value = NULL;
	items[len].flags = 0;
	
	newtWinEntries(StringValuePtr(RARRAY_PTR(args)[0]), StringValuePtr(RARRAY_PTR(args)[1]),
				   NUM2INT(RARRAY_PTR(args)[2]),
				   NUM2INT(RARRAY_PTR(args)[3]), NUM2INT(RARRAY_PTR(args)[4]),
				   NUM2INT(RARRAY_PTR(args)[5]),
				   items, StringValuePtr(RARRAY_PTR(args)[7]), NULL);
	for (i = 0; i < len; i++) {
	  rb_ary_push(ary, rb_str_new2(entries[i]));
	}
	return ary;
  }	else if (len == 9) {
	Check_Type(RARRAY_PTR(args)[6], T_ARRAY);

	len = RARRAY_LEN(RARRAY_PTR(args)[6]);
	if (len > 8) rb_raise(rb_eArgError, "8 or less arguments required");
	items = ALLOCA_N(struct newtWinEntry, len + 1);
	for (i = 0; i < len; i++) {
	  Check_Type(RARRAY_PTR(RARRAY_PTR(args)[6])[i], T_STRING);
	  items[i].text = StringValuePtr(RARRAY_PTR(RARRAY_PTR(args)[6])[i]);
	  items[i].value = entries + i;
	  items[i].flags = 0;
	}
	items[len].text = NULL;
	items[len].value = NULL;
	items[len].flags = 0;

	newtWinEntries(StringValuePtr(RARRAY_PTR(args)[0]), StringValuePtr(RARRAY_PTR(args)[1]),
				   NUM2INT(RARRAY_PTR(args)[2]),
				   NUM2INT(RARRAY_PTR(args)[3]), NUM2INT(RARRAY_PTR(args)[4]),
				   NUM2INT(RARRAY_PTR(args)[5]),
				   items, StringValuePtr(RARRAY_PTR(args)[7]), StringValuePtr(RARRAY_PTR(args)[8]), NULL);
	for (i = 0; i < len; i++) {
	  rb_ary_push(ary, rb_str_new2(entries[i]));
	}
	return ary;
  } else {
	rb_raise(rb_eArgError, "8 or 9 arguments required");
  }

  return Qnil;
}

/*
 * Widget_callback_function
 *
 */ 
void
rb_ext_Widget_callback_function(newtComponent co, void *proc)
{
  VALUE widget;

  widget = Data_Wrap_Struct(cWidget, 0, 0, co);
  if(SYMBOL_P(proc)){
    rb_funcall(rb_mKernel, SYM2ID((VALUE)proc), 1, widget);
  }
  else{
    rb_funcall((VALUE)proc, rb_call_id, 1, widget);
  };
};

/*
 * Widget_callback
 *
 */
static VALUE
rb_ext_Widget_callback(int argc, VALUE argv[], VALUE self)
{
  newtComponent co;
  VALUE arg1, value;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  switch(rb_scan_args(argc, argv, "01", &arg1)){
  case 0:
    value = rb_hash_aref(rb_ext_Widget_CALLBACK_HASH, self);
    break;
  case 1:
    rb_hash_aset(rb_ext_Widget_CALLBACK_HASH, self, arg1);
    newtComponentAddCallback(co, rb_ext_Widget_callback_function, (void*)arg1);
    value = Qnil;
    break;
  default:
    rb_bug("rb_ext_Widget_callback");
  };

  return value;
}

/*
 * Widget_equal
 *
 */
static VALUE
rb_ext_Widget_equal(VALUE self, VALUE widget)
{
  newtComponent co, co2;

  if (NIL_P(widget)) return Qfalse;
  if (self == widget) return Qtrue;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  Data_Get_Struct(widget, struct newtComponent_struct, co2);
  /*fprintf(stderr, "* %p %p", co, co2);*/
  if (co == co2) return Qtrue;
  return Qfalse;
}

/*
 * Label_new
 *
 */
static VALUE
rb_ext_Label_new(VALUE self, VALUE left, VALUE top, VALUE text)
{
  newtComponent co;

  co = newtLabel(NUM2INT(left), NUM2INT(top), StringValuePtr(text));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Label_SetText
 *
 */
static VALUE
rb_ext_Label_SetText(VALUE self, VALUE text)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtLabelSetText(co, StringValuePtr(text));
  return Qnil;
}

/*
 * CompactButton_new
 *
 */
static VALUE
rb_ext_CompactButton_new(VALUE self, VALUE left, VALUE top, VALUE text)
{
  newtComponent co;

  co = newtCompactButton(NUM2INT(left), NUM2INT(top), StringValuePtr(text));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Button_new
 *
 */
static VALUE
rb_ext_Button_new(VALUE self, VALUE left, VALUE top, VALUE text)
{
  newtComponent co;

  co = newtButton(NUM2INT(left), NUM2INT(top), StringValuePtr(text));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Checkbox_new
 *
 */
static VALUE
rb_ext_Checkbox_new(VALUE self, VALUE left, VALUE top, VALUE text,
				  VALUE defValue, VALUE seq)
{
  newtComponent co;

  if (NIL_P(seq)) {
	co = newtCheckbox(NUM2INT(left), NUM2INT(top), StringValuePtr(text),
					  StringValuePtr(defValue)[0], NULL, NULL);
  } else {
	co = newtCheckbox(NUM2INT(left), NUM2INT(top), StringValuePtr(text),
					  StringValuePtr(defValue)[0], StringValuePtr(seq), NULL);
  }
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Checkbox_GetValue
 *
 */
static VALUE
rb_ext_Checkbox_GetValue(VALUE self)
{
  newtComponent co;
  char value[10];

  Data_Get_Struct(self, struct newtComponent_struct, co);
  value[0] = newtCheckboxGetValue(co);
  value[1] = '\0';
  return rb_str_new2(value);
}

/*
 * Checkbox_SetValue
 *
 */
static VALUE
rb_ext_Checkbox_SetValue(VALUE self, VALUE value)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  if (RSTRING(value)->len > 0) {
	newtCheckboxSetValue(co, StringValuePtr(value)[0]);
  }
  return Qnil;
}

/*
 * Checkbox_SetFlags
 *
 */
static VALUE
rb_ext_Checkbox_SetFlags(VALUE self, VALUE args)
{
  newtComponent co;
  long len;

  len = RARRAY_LEN(args);
  if (len == 1) {
	Data_Get_Struct(self, struct newtComponent_struct, co);
	newtCheckboxSetFlags(co, NUM2INT(RARRAY_PTR(args)[0]), NEWT_FLAGS_SET);
  } else if (len == 2) {
	Data_Get_Struct(self, struct newtComponent_struct, co);
	newtCheckboxSetFlags(co, NUM2INT(RARRAY_PTR(args)[0]), NUM2INT(RARRAY_PTR(args)[1]));
  } else {
	rb_raise(rb_eArgError, "1 argument or 2 arguments required");
  }

  return Qnil;
}

/*
 * RadioButton_new
 *
 */
static VALUE
rb_ext_RadioButton_new(VALUE self, VALUE left, VALUE top, VALUE text,
					   VALUE isDefault, VALUE prevButton)
{
  newtComponent co, cco;

  if (NIL_P(prevButton)) {
	co = newtRadiobutton(NUM2INT(left), NUM2INT(top), StringValuePtr(text),
						 NUM2INT(isDefault), NULL);
  } else {
	Data_Get_Struct(prevButton, struct newtComponent_struct, cco);
	co = newtRadiobutton(NUM2INT(left), NUM2INT(top), StringValuePtr(text),
						 NUM2INT(isDefault), cco);
  }
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Listbox_new
 *
 */
static VALUE
rb_ext_Listbox_new(VALUE self, VALUE left, VALUE top, VALUE height, VALUE flags)
{
  newtComponent co;

  co = newtListbox(NUM2INT(left), NUM2INT(top), NUM2INT(height), NUM2INT(flags));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Listbox_GetCurrent
 *
 */
static VALUE
rb_ext_Listbox_GetCurrent(VALUE self)
{
  newtComponent co;
  int i = 0;
  int *ip;
  char *p;

  ip = &i;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  /*p = (char *)newtListboxGetCurrent(co);*/
  ip = (int *)newtListboxGetCurrent(co);
  /*return rb_str_new2(p);*/
  return INT2NUM(i);
}

/*
 * Listbox_SetCurrent
 *
 */
static VALUE
rb_ext_Listbox_SetCurrent(VALUE self, VALUE num)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtListboxSetCurrent(co, NUM2INT(num));
  return Qnil;
}

/*
 * Listbox_SetCurrentByKey
 *
 */
static VALUE
rb_ext_Listbox_SetCurrentByKey(VALUE self, VALUE key)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(key)) {
  case T_STRING:
	newtListboxSetCurrentByKey(co, (void *)StringValuePtr(key));
	break;
  case T_FIXNUM:
	newtListboxSetCurrentByKey(co, (void *)NUM2INT(key));
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
}

/*
 * Listbox_SetEntry
 *
 */
static VALUE
rb_ext_Listbox_SetEntry(VALUE self, VALUE num, VALUE text)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtListboxSetEntry(co, NUM2INT(num), StringValuePtr(text));
  return Qnil;
}

/*
 * Listbox_SetWidth
 *
 */
static VALUE
rb_ext_Listbox_SetWidth(VALUE self, VALUE width)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtListboxSetWidth(co, NUM2INT(width));
  return Qnil;
}

/*
 * Listbox_SetData
 *
 */
static VALUE
rb_ext_Listbox_SetData(VALUE self, VALUE num, VALUE data)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(data)) {
  case T_STRING:
	newtListboxSetData(co, NUM2INT(num), (void *)StringValuePtr(data));
	break;
  case T_FIXNUM:
	newtListboxSetData(co, NUM2INT(num), (void *)NUM2INT(data));
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
}

/*
 * Listbox_AppendEntry
 *
 */
static VALUE
rb_ext_Listbox_AppendEntry(VALUE self, VALUE text, VALUE data)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(data)) {
  case T_STRING:
	newtListboxAppendEntry(co, StringValuePtr(text), (void *)StringValuePtr(data));
	break;
  case T_FIXNUM:
	newtListboxAppendEntry(co, StringValuePtr(text), (void *)NUM2INT(data));
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
}

/*
 * Listbox_InsertEntry
 *
 */
static VALUE
rb_ext_Listbox_InsertEntry(VALUE self, VALUE text, VALUE data, VALUE key)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(data)) {
  case T_STRING:
	switch(TYPE(key)) {
	case T_STRING:
	  newtListboxInsertEntry(co, StringValuePtr(text), (void *)StringValuePtr(data), (void *)StringValuePtr(key));
	  break;
	case T_FIXNUM:
	  newtListboxInsertEntry(co, StringValuePtr(text), (void *)StringValuePtr(data), (void *)NUM2INT(key));
	  break;
	default:
	  rb_raise(rb_eTypeError, "String or Fixnum expected");
	  break;
	}
  case T_FIXNUM:
	switch(TYPE(key)) {
	case T_STRING:
	  newtListboxInsertEntry(co, StringValuePtr(text), (void *)NUM2INT(data), (void *)StringValuePtr(key));
	  break;
	case T_FIXNUM:
	  newtListboxInsertEntry(co, StringValuePtr(text), (void *)NUM2INT(data), (void *)NUM2INT(key));
	  break;
	default:
	  rb_raise(rb_eTypeError, "String or Fixnum expected");
	  break;
	}
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
}

/*
 * Listbox_DeleteEntry
 *
 */
static VALUE
rb_ext_Listbox_DeleteEntry(VALUE self, VALUE data)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(data)) {
  case T_STRING:
	newtListboxDeleteEntry(co, (void *)StringValuePtr(data));
	break;
  case T_FIXNUM:
	newtListboxDeleteEntry(co, (void *)NUM2INT(data));
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
}

/*
 * Listbox_Clear
 *
 */
static VALUE
rb_ext_Listbox_Clear(VALUE self)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  newtListboxClear(co);
  return Qnil;
}

/*
 * Listbox_ClearSelection
 *
 */
static VALUE
rb_ext_Listbox_ClearSelection(VALUE self)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  newtListboxClearSelection(co);
  return Qnil;
}

/*
 * Listbox_SelectItem
 *
 */
static VALUE
rb_ext_Listbox_SelectItem(VALUE self, VALUE key, VALUE sense)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(key)) {
  case T_STRING:
	newtListboxSelectItem(co, (void *)StringValuePtr(key), NUM2INT(sense));
	break;
  case T_FIXNUM:
	newtListboxSelectItem(co, (void *)NUM2INT(key), NUM2INT(sense));
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
}

/*
 * CheckboxTree_new
 *
 */
static VALUE
rb_ext_CheckboxTree_new(VALUE self, VALUE left, VALUE top, VALUE height, VALUE flags)
{
  newtComponent co;

  co = newtCheckboxTree(NUM2INT(left), NUM2INT(top), NUM2INT(height), NUM2INT(flags));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * CheckboxTree_AddItem
 *
 */
static VALUE
rb_ext_CheckboxTree_AddItem(VALUE self, VALUE args)
/*rb_ext_CheckboxTree_AddItem(VALUE self, VALUE text, VALUE data, VALUE flags)*/
	 /*, VALUE index)*/
{
  newtComponent co;
#if 1
  int i, len;
  int *indexes;

  len = RARRAY_LEN(args);
  if (len < 4) {
	rb_raise(rb_eArgError, "4 arguments required");
  } else {
	Data_Get_Struct(self, struct newtComponent_struct, co);

	indexes = ALLOCA_N(int, (len - 4) + 2);
	for (i = 0; i < (len - 4) + 1; i++) {
	  indexes[i] = NUM2INT(RARRAY_PTR(args)[i+3]);
	}
	indexes[(len - 4) + 1] = NEWT_ARG_LAST;

	switch(TYPE(RARRAY_PTR(args)[1])) {
	case T_STRING:
	  newtCheckboxTreeAddArray(co, StringValuePtr(RARRAY_PTR(args)[0]), (void *)StringValuePtr(RARRAY_PTR(args)[1]),
							   NUM2INT(RARRAY_PTR(args)[2]), indexes);
	  break;
	case T_FIXNUM:
	  newtCheckboxTreeAddArray(co, StringValuePtr(RARRAY_PTR(args)[0]), (void *)NUM2INT(RARRAY_PTR(args)[1]),
							   NUM2INT(RARRAY_PTR(args)[2]), indexes);
	  break;
	default:
	  rb_raise(rb_eTypeError, "String or Fixnum expected");
	  break;
	}
	return Qnil;
  }
#else
  Data_Get_Struct(self, struct newtComponent_struct, co);

  switch(TYPE(data)) {
  case T_STRING:
	newtCheckboxTreeAddItem(co, StringValuePtr(text), (void *)StringValuePtr(data), NUM2INT(flags), NEWT_ARG_APPEND, NEWT_ARG_LAST);
	break;
  case T_FIXNUM:
	newtCheckboxTreeAddItem(co, StringValuePtr(text), (void *)NUM2INT(data), NUM2INT(flags), NEWT_ARG_APPEND, NEWT_ARG_LAST);
	break;
  default:
	rb_raise(rb_eTypeError, "String or Fixnum expected");
	break;
  }
  return Qnil;
#endif
}

/*
 * CheckboxTreeMulti_new
 *
 */
static VALUE
rb_ext_CheckboxTreeMulti_new(VALUE self, VALUE left, VALUE top, VALUE height, VALUE seq, VALUE flags)
{
  newtComponent co;

  if (NIL_P(seq)) {
	co = newtCheckboxTreeMulti(NUM2INT(left), NUM2INT(top), NUM2INT(height), NULL, NUM2INT(flags));
  } else {
	co = newtCheckboxTreeMulti(NUM2INT(left), NUM2INT(top), NUM2INT(height), StringValuePtr(seq), NUM2INT(flags));
  }
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Textbox_new
 *
 */
static VALUE
rb_ext_Textbox_new(VALUE self, VALUE left, VALUE top, VALUE width, VALUE height, VALUE flags)
{
  newtComponent co;

  co = newtTextbox(NUM2INT(left), NUM2INT(top), NUM2INT(width), NUM2INT(height), NUM2INT(flags));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Textbox_SetText
 *
 */
static VALUE
rb_ext_Textbox_SetText(VALUE self, VALUE text)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtTextboxSetText(co, StringValuePtr(text));
  return Qnil;
}

/*
 * Textbox_SetHeight
 *
 */
static VALUE
rb_ext_Textbox_SetHeight(VALUE self, VALUE height)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtTextboxSetHeight(co, NUM2INT(height));
  return Qnil;
}

/*
 * Textbox_GetNumLines
 *
 */
static VALUE
rb_ext_Textbox_GetNumLines(VALUE self)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  return INT2NUM(newtTextboxGetNumLines(co));
}

/*
 * TextboxReflowed_new
 *
 */
static VALUE
rb_ext_TextboxReflowed_new(VALUE self, VALUE left, VALUE top, VALUE text, VALUE width, VALUE flexDown, VALUE flexUp, VALUE flags)
{
  newtComponent co;

  co = newtTextboxReflowed(NUM2INT(left), NUM2INT(top), StringValuePtr(text), NUM2INT(width),
						   NUM2INT(flexDown), NUM2INT(flexUp), NUM2INT(flags));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Form_Destroy
 *
 */
static void
rb_ext_Form_Destroy(VALUE self)
{
  newtComponent form;

  if (self) {
	Data_Get_Struct(cForm, struct newtComponent_struct, form);
	newtFormDestroy(form);
  }
}

/*
 * Form_new
 *
 */
static VALUE
rb_ext_Form_new(VALUE self, VALUE left, VALUE top, VALUE text)
{
  newtComponent co;

  co = newtForm(NULL, NULL, 0);
  return Data_Wrap_Struct(self, 0, rb_ext_Form_Destroy, co);
}

/*
 * Form_SetBackground
 *
 */
static VALUE
rb_ext_Form_SetBackground(VALUE self, VALUE color)
{
  newtComponent form;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  newtFormSetBackground(form, NUM2INT(color));
  return Qnil;
}

#if 0
static VALUE
rb_ext_Form_AddComponent(VALUE self, VALUE co)
{
  newtComponent form, cco;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  Data_Get_Struct(co, struct newtComponent_struct, cco);
  newtFormAddComponent(form, cco);
  return Qnil;
}
#endif

/*
 * Form_AddComponents
 *
 */
static VALUE
rb_ext_Form_AddComponents(VALUE self, VALUE co)
{
  int i;
  newtComponent form, cco;

  Data_Get_Struct(self, struct newtComponent_struct, form);

  for (i = 0; i < RARRAY_LEN(co); i++) {
	Data_Get_Struct(RARRAY_PTR(co)[i], struct newtComponent_struct, cco);
	newtFormAddComponent(form, cco);
  }
  return Qnil;
}

/*
 * Form_SetHeight
 *
 */
static VALUE
rb_ext_Form_SetHeight(VALUE self, VALUE height)
{
  newtComponent form;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  newtFormSetHeight(form, NUM2INT(height));
  return Qnil;
}

/*
 * Form_SetWidth
 *
 */
static VALUE
rb_ext_Form_SetWidth(VALUE self, VALUE width)
{
  newtComponent form;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  newtFormSetWidth(form, NUM2INT(width));
  return Qnil;
}

/*
 * Run_Form
 *
 */
static VALUE
rb_ext_Run_Form(VALUE self)
{
  newtComponent form, co;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  co = newtRunForm(form);
  return Data_Wrap_Struct(cWidget, 0, 0, co);
}

/*
 * Form_DrawForm
 *
 */
static VALUE
rb_ext_Form_DrawForm(VALUE self)
{
  newtComponent form;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  newtDrawForm(form);
  return Qnil;
}

/*
 * Form_AddHotKey
 *
 */
static VALUE
rb_ext_Form_AddHotKey(VALUE self, VALUE key)
{
  newtComponent form;

  Data_Get_Struct(self, struct newtComponent_struct, form);
  newtFormAddHotKey(form, NUM2INT(key));
  return Qnil;
}

/*
 * Entry_new
 *
 */
static VALUE
rb_ext_Entry_new(VALUE self, VALUE left, VALUE top, VALUE initialValue, VALUE width, VALUE flags)
{
  newtComponent co;

  co = newtEntry(NUM2INT(left), NUM2INT(top), StringValuePtr(initialValue), NUM2INT(width),
				 NULL, NUM2INT(flags));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Entry_Set
 *
 */
static VALUE
rb_ext_Entry_Set(VALUE self, VALUE value, VALUE cursorAtEnd)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  switch(TYPE(cursorAtEnd)) {
  case T_TRUE:
	newtEntrySet(co, StringValuePtr(value), 1);
	break;
  case T_FALSE:
	newtEntrySet(co, StringValuePtr(value), 0);
	break;
  case T_FIXNUM:
	newtEntrySet(co, StringValuePtr(value), NUM2INT(cursorAtEnd));
	break;
  default:
	rb_raise(rb_eTypeError, "Boolean or Fixnum expected");
	break;
  }
	  
  return Qnil;
}

/*
 * Entry_GetValue
 *
 */
static VALUE
rb_ext_Entry_GetValue(VALUE self)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  return rb_str_new2(newtEntryGetValue(co));
}

/*
 * Entry_SetFlags
 *
 */
static VALUE
rb_ext_Entry_SetFlags(VALUE self, VALUE args)
{
  newtComponent co;
  long len;

  len = RARRAY_LEN(args);
  if (len == 1) {
	Data_Get_Struct(self, struct newtComponent_struct, co);
	newtEntrySetFlags(co, NUM2INT(RARRAY_PTR(args)[0]), NEWT_FLAGS_SET);
  } else if (len == 2) {
	Data_Get_Struct(self, struct newtComponent_struct, co);
	newtEntrySetFlags(co, NUM2INT(RARRAY_PTR(args)[0]), NUM2INT(RARRAY_PTR(args)[1]));
  } else {
	rb_raise(rb_eArgError, "1 argument or 2 arguments required");
  }
  return Qnil;
}

/*
 * Scale_new
 *
 */
static VALUE
rb_ext_Scale_new(VALUE self, VALUE left, VALUE top, VALUE width, VALUE fullValue)
{
  newtComponent co;

  co = newtScale(NUM2INT(left), NUM2INT(top), NUM2INT(width), NUM2INT(fullValue));
  return Data_Wrap_Struct(self, 0, 0, co);
}

/*
 * Scale_Set
 *
 */
static VALUE
rb_ext_Scale_Set(VALUE self, VALUE amount)
{
  newtComponent co;

  Data_Get_Struct(self, struct newtComponent_struct, co);
  newtScaleSet(co, NUM2INT(amount));
  return Qnil;
}

/*
 * Grid_free
 *
 */
static void
rb_ext_Grid_free(VALUE self)
{
  newtGrid grid;

  if (self) {
	Data_Get_Struct(cGrid, struct grid_s, grid);
	newtGridFree(grid, 1);
  }
}

/*
 * Grid_new
 *
 */
static VALUE
rb_ext_Grid_new(VALUE self, VALUE cols, VALUE rows)
{
  newtGrid grid;

  grid = newtCreateGrid(NUM2INT(cols), NUM2INT(rows));
  /*return Data_Wrap_Struct(self, 0, 0, grid);*/
  return Data_Wrap_Struct(self, 0, rb_ext_Grid_free, grid);
}

/*
 * Grid_SetField
 *
 */
static VALUE
rb_ext_Grid_SetField(VALUE self, VALUE col, VALUE row, VALUE type, VALUE val,
					 VALUE padLeft, VALUE padTop, VALUE padRight, VALUE padBottom,
					 VALUE anchor, VALUE flags)
{
  newtGrid grid;
  newtComponent co;

  Data_Get_Struct(self, struct grid_s, grid);
  Data_Get_Struct(val, struct newtComponent_struct, co);
  newtGridSetField(grid, NUM2INT(col), NUM2INT(row), NUM2INT(type), co,
				   NUM2INT(padLeft), NUM2INT(padTop), NUM2INT(padRight), NUM2INT(padBottom),
				   NUM2INT(anchor), NUM2INT(flags));
  return Qnil;
}

/*
 * Grid_WrappedWindow
 *
 */
static VALUE
rb_ext_Grid_WrappedWindow(VALUE self, VALUE args)
{
  newtGrid grid;
  long len;

  len = RARRAY_LEN(args);
  if (len == 1) {
	Data_Get_Struct(self, struct grid_s, grid);
	newtGridWrappedWindow(grid, StringValuePtr(RARRAY_PTR(args)[0]));
  } else if (len == 3) {
	Data_Get_Struct(self, struct grid_s, grid);
	newtGridWrappedWindowAt(grid, StringValuePtr(RARRAY_PTR(args)[0]),
							NUM2INT(StringValuePtr(RARRAY_PTR(args)[1])), NUM2INT(StringValuePtr(RARRAY_PTR(args)[2])));
  } else {
	rb_raise(rb_eArgError, "1 argument or 3 arguments required");
  }
				   
  return Qnil;
}

/*
 * Grid_GetSize
 *
 */
static VALUE
rb_ext_Grid_GetSize(VALUE self)
{
  int width, height;
  newtGrid grid;
  VALUE ary = rb_ary_new2(2);

  Data_Get_Struct(self, struct grid_s, grid);
  newtGridGetSize(grid, &width, &height);
  rb_ary_push(ary, INT2NUM(width));
  rb_ary_push(ary, INT2NUM(height));

  return ary;
}

/*
 * Init_ruby_newt
 *
 */
void
Init_ruby_newt(){
  mNewt = rb_define_module("Newt");
  rb_define_module_function(mNewt, "reflow_text", rb_ext_ReflowText, 4);

  mScreen = rb_define_class_under(mNewt, "Screen", rb_cObject);
  rb_define_module_function(mScreen, "new", rb_ext_Screen_new, 0);
  rb_define_module_function(mScreen, "init", rb_ext_Screen_Init, 0);
  rb_define_module_function(mScreen, "cls", rb_ext_Screen_Cls, 0);
  rb_define_module_function(mScreen, "finish", rb_ext_Screen_Finished, 0);
  rb_define_module_function(mScreen, "wait_for_key", rb_ext_Screen_WaitForKey, 0);
  rb_define_module_function(mScreen, "clear_keybuffer", rb_ext_Screen_ClearKeyBuffer, 0);
  rb_define_module_function(mScreen, "open_window", rb_ext_Screen_OpenWindow, 5);
  rb_define_module_function(mScreen, "centered_window", rb_ext_Screen_CenteredWindow, 3);
  rb_define_module_function(mScreen, "pop_window", rb_ext_Screen_PopWindow, 0);
  rb_define_module_function(mScreen, "refresh", rb_ext_Screen_Refresh, 0);
  rb_define_module_function(mScreen, "suspend", rb_ext_Screen_Suspend, 0);
  rb_define_module_function(mScreen, "resume", rb_ext_Screen_Resume, 0);
  rb_define_module_function(mScreen, "push_helpline", rb_ext_Screen_PushHelpLine, 1);
  rb_define_module_function(mScreen, "redraw_helpline", rb_ext_Screen_RedrawHelpLine, 0);
  rb_define_module_function(mScreen, "pop_helpline", rb_ext_Screen_PopHelpLine, 0);
  rb_define_module_function(mScreen, "draw_roottext", rb_ext_Screen_DrawRootText, 3);
  rb_define_module_function(mScreen, "bell", rb_ext_Screen_Bell, 0);
  rb_define_module_function(mScreen, "size", rb_ext_Screen_Size, 0);
  rb_define_module_function(mScreen, "win_message", rb_ext_Screen_WinMessage, -2);
  rb_define_module_function(mScreen, "win_choice", rb_ext_Screen_WinChoice, -2);
  rb_define_module_function(mScreen, "win_menu", rb_ext_Screen_WinMenu, -2);
  rb_define_module_function(mScreen, "win_entries", rb_ext_Screen_WinEntries, -2);

  rb_ext_Widget_CALLBACK_HASH = rb_hash_new();
  rb_define_const(mNewt, "CALLBACK_HASH", rb_ext_Widget_CALLBACK_HASH);
  rb_call_id = rb_intern("call");

  cWidget = rb_define_class_under(mNewt, "Widget", rb_cObject);
  rb_define_method(cWidget, "callback", rb_ext_Widget_callback, -1);
  rb_define_method(cWidget, "==", rb_ext_Widget_equal, 1);

  cCompactButton = rb_define_class_under(mNewt, "CompactButton", cWidget);
  rb_define_singleton_method(cCompactButton, "new", rb_ext_CompactButton_new, 3);
  
  cButton = rb_define_class_under(mNewt, "Button", cWidget);
  rb_define_singleton_method(cButton, "new", rb_ext_Button_new, 3);
  
  cCheckbox = rb_define_class_under(mNewt, "Checkbox", cWidget);
  rb_define_singleton_method(cCheckbox, "new", rb_ext_Checkbox_new, 5);
  rb_define_method(cCheckbox, "get", rb_ext_Checkbox_GetValue, 0);
  rb_define_method(cCheckbox, "set", rb_ext_Checkbox_SetValue, 1);
  rb_define_method(cCheckbox, "set_flags", rb_ext_Checkbox_SetFlags, -2);
  
  cRadioButton = rb_define_class_under(mNewt, "RadioButton", cWidget);
  rb_define_singleton_method(cRadioButton, "new", rb_ext_RadioButton_new, 5);

  cLabel = rb_define_class_under(mNewt, "Label", cWidget);
  rb_define_singleton_method(cLabel, "new", rb_ext_Label_new, 3);
  rb_define_method(cLabel, "set_text", rb_ext_Label_SetText, 1);
  
  cListbox = rb_define_class_under(mNewt, "Listbox", cWidget);
  rb_define_singleton_method(cListbox, "new", rb_ext_Listbox_new, 4);
  rb_define_method(cListbox, "get_current", rb_ext_Listbox_GetCurrent, 0);
  rb_define_method(cListbox, "set_current", rb_ext_Listbox_SetCurrent, 1);
  rb_define_method(cListbox, "setCurrentByKey", rb_ext_Listbox_SetCurrentByKey, 1);
  rb_define_method(cListbox, "set_width", rb_ext_Listbox_SetWidth, 1);
  rb_define_method(cListbox, "setData", rb_ext_Listbox_SetData, 2);
  rb_define_method(cListbox, "append", rb_ext_Listbox_AppendEntry, 2);
  rb_define_method(cListbox, "insert", rb_ext_Listbox_InsertEntry, 3);
  rb_define_method(cListbox, "set", rb_ext_Listbox_SetEntry, 2);
  rb_define_method(cListbox, "delete", rb_ext_Listbox_DeleteEntry, 1);
  rb_define_method(cListbox, "clear", rb_ext_Listbox_Clear, 0);
  rb_define_method(cListbox, "clearSelection", rb_ext_Listbox_ClearSelection, 0);
  rb_define_method(cListbox, "select", rb_ext_Listbox_SelectItem, 2);

  cCheckboxTree = rb_define_class_under(mNewt, "CheckboxTree", cWidget);
  rb_define_singleton_method(cCheckboxTree, "new", rb_ext_CheckboxTree_new, 4);
  /*rb_define_method(cCheckboxTree, "addItem", rb_ext_CheckboxTree_AddItem, 3);*/
  rb_define_method(cCheckboxTree, "add", rb_ext_CheckboxTree_AddItem, -2);

  cCheckboxTreeMulti = rb_define_class_under(mNewt, "CheckboxTreeMulti", cCheckboxTree);
  rb_define_singleton_method(cCheckboxTreeMulti, "new", rb_ext_CheckboxTreeMulti_new, 5);

  cTextbox = rb_define_class_under(mNewt, "Textbox", cWidget);
  rb_define_singleton_method(cTextbox, "new", rb_ext_Textbox_new, 5);
  rb_define_method(cTextbox, "set_text", rb_ext_Textbox_SetText, 1);
  rb_define_method(cTextbox, "set_height", rb_ext_Textbox_SetHeight, 1);
  rb_define_method(cTextbox, "get_num_lines", rb_ext_Textbox_GetNumLines, 0);

  cTextboxReflowed = rb_define_class_under(mNewt, "TextboxReflowed", cWidget);
  rb_define_singleton_method(cTextboxReflowed, "new", rb_ext_TextboxReflowed_new, 7);

  cForm = rb_define_class_under(mNewt, "Form", cWidget);
  rb_define_singleton_method(cForm, "new", rb_ext_Form_new, 0);
  /*rb_define_method(cForm, "setSize", rb_ext_Form_SetSize, 0);*/
  /*rb_define_method(cForm, "destroy", rb_ext_Form_Destroy, 0);*/
  rb_define_method(cForm, "set_background", rb_ext_Form_SetBackground, 1);
  /*rb_define_method(cForm, "addComponent", rb_ext_Form_AddComponent, 1);*/
  rb_define_method(cForm, "add", rb_ext_Form_AddComponents, -2);
  rb_define_method(cForm, "set_height", rb_ext_Form_SetHeight, 1);
  rb_define_method(cForm, "set_width", rb_ext_Form_SetWidth, 1);
  rb_define_method(cForm, "run", rb_ext_Run_Form, 0);
  rb_define_method(cForm, "draw", rb_ext_Form_DrawForm, 0);
  rb_define_method(cForm, "add_hotkey", rb_ext_Form_AddHotKey, 1);

  cEntry = rb_define_class_under(mNewt, "Entry", cWidget);
  rb_define_singleton_method(cEntry, "new", rb_ext_Entry_new, 5);
  rb_define_method(cEntry, "set", rb_ext_Entry_Set, 2);
  rb_define_method(cEntry, "get", rb_ext_Entry_GetValue, 0);
  rb_define_method(cEntry, "set_flags", rb_ext_Entry_SetFlags, -2);

  cScale = rb_define_class_under(mNewt, "Scale", cWidget);
  rb_define_singleton_method(cScale, "new", rb_ext_Scale_new, 4);
  rb_define_method(cScale, "set", rb_ext_Scale_Set, 1);


  cGrid = rb_define_class_under(mNewt, "Grid", cWidget);
  rb_define_singleton_method(cGrid, "new", rb_ext_Grid_new, 2);
  /*rb_define_method(cGrid, "destroy", rb_ext_Grid_free, 0);*/
  rb_define_method(cGrid, "set_field", rb_ext_Grid_SetField, 10);
  rb_define_method(cGrid, "wrapped_window", rb_ext_Grid_WrappedWindow, -2);
  rb_define_method(cGrid, "get_size", rb_ext_Grid_GetSize, 0);
  
  rb_define_const(mNewt, "COLORSET_ROOT", INT2FIX(NEWT_COLORSET_ROOT));
  rb_define_const(mNewt, "COLORSET_BORDER", INT2FIX(NEWT_COLORSET_BORDER));
  rb_define_const(mNewt, "COLORSET_WINDOW", INT2FIX(NEWT_COLORSET_WINDOW));
  rb_define_const(mNewt, "COLORSET_SHADOW", INT2FIX(NEWT_COLORSET_SHADOW));
  rb_define_const(mNewt, "COLORSET_TITLE", INT2FIX(NEWT_COLORSET_TITLE));
  rb_define_const(mNewt, "COLORSET_BUTTON", INT2FIX(NEWT_COLORSET_BUTTON));
  rb_define_const(mNewt, "COLORSET_ACTBUTTON", INT2FIX(NEWT_COLORSET_ACTBUTTON));
  rb_define_const(mNewt, "COLORSET_CHECKBOX", INT2FIX(NEWT_COLORSET_CHECKBOX));
  rb_define_const(mNewt, "COLORSET_ACTCHECKBOX", INT2FIX(NEWT_COLORSET_ACTCHECKBOX));
  rb_define_const(mNewt, "COLORSET_ENTRY", INT2FIX(NEWT_COLORSET_ENTRY));
  rb_define_const(mNewt, "COLORSET_LABEL", INT2FIX(NEWT_COLORSET_LABEL));
  rb_define_const(mNewt, "COLORSET_LISTBOX", INT2FIX(NEWT_COLORSET_LISTBOX));
  rb_define_const(mNewt, "COLORSET_ACTLISTBOX", INT2FIX(NEWT_COLORSET_ACTLISTBOX));
  rb_define_const(mNewt, "COLORSET_TEXTBOX", INT2FIX(NEWT_COLORSET_TEXTBOX));
  rb_define_const(mNewt, "COLORSET_ACTTEXTBOX", INT2FIX(NEWT_COLORSET_ACTTEXTBOX));
  rb_define_const(mNewt, "COLORSET_HELPLINE", INT2FIX(NEWT_COLORSET_HELPLINE));
  rb_define_const(mNewt, "COLORSET_ROOTTEXT", INT2FIX(NEWT_COLORSET_ROOTTEXT));
  rb_define_const(mNewt, "COLORSET_EMPTYSCALE", INT2FIX(NEWT_COLORSET_EMPTYSCALE));
  rb_define_const(mNewt, "COLORSET_FULLSCALE", INT2FIX(NEWT_COLORSET_FULLSCALE));
  rb_define_const(mNewt, "COLORSET_DISENTRY", INT2FIX(NEWT_COLORSET_DISENTRY));
  rb_define_const(mNewt, "COLORSET_COMPACTBUTTON", INT2FIX(NEWT_COLORSET_COMPACTBUTTON));
  rb_define_const(mNewt, "COLORSET_ACTSELLISTBOX", INT2FIX(NEWT_COLORSET_ACTSELLISTBOX));
  rb_define_const(mNewt, "COLORSET_SELLISTBOX", INT2FIX(NEWT_COLORSET_SELLISTBOX));

  rb_define_const(mNewt, "ARG_APPEND", INT2FIX(NEWT_ARG_APPEND));

  rb_define_const(mNewt, "FLAGS_SET", INT2FIX(NEWT_FLAGS_SET));
  rb_define_const(mNewt, "FLAGS_RESET", INT2FIX(NEWT_FLAGS_RESET));
  rb_define_const(mNewt, "FLAGS_TOGGLE", INT2FIX(NEWT_FLAGS_TOGGLE));

  rb_define_const(mNewt, "FLAG_RETURNEXIT", INT2FIX(NEWT_FLAG_RETURNEXIT));
  rb_define_const(mNewt, "FLAG_HIDDEN", INT2FIX(NEWT_FLAG_HIDDEN));
  rb_define_const(mNewt, "FLAG_SCROLL", INT2FIX(NEWT_FLAG_SCROLL));
  rb_define_const(mNewt, "FLAG_DISABLED", INT2FIX(NEWT_FLAG_DISABLED));
  rb_define_const(mNewt, "FLAG_BORDER", INT2FIX(NEWT_FLAG_BORDER));
  rb_define_const(mNewt, "FLAG_WRAP", INT2FIX(NEWT_FLAG_WRAP));
  rb_define_const(mNewt, "FLAG_NOF12", INT2FIX(NEWT_FLAG_NOF12));
  rb_define_const(mNewt, "FLAG_MULTIPLE", INT2FIX(NEWT_FLAG_MULTIPLE));
  rb_define_const(mNewt, "FLAG_SELECTED", INT2FIX(NEWT_FLAG_SELECTED));
  rb_define_const(mNewt, "FLAG_CHECKBOX", INT2FIX(NEWT_FLAG_CHECKBOX));
  
  rb_define_const(mNewt, "ANCHOR_LEFT", INT2FIX(NEWT_ANCHOR_LEFT));
  rb_define_const(mNewt, "ANCHOR_RIGHT", INT2FIX(NEWT_ANCHOR_RIGHT));
  rb_define_const(mNewt, "ANCHOR_TOP", INT2FIX(NEWT_ANCHOR_TOP));
  rb_define_const(mNewt, "ANCHOR_BOTTOM", INT2FIX(NEWT_ANCHOR_BOTTOM));

  rb_define_const(mNewt, "GRID_FLAG_GROWX", INT2FIX(NEWT_GRID_FLAG_GROWX));
  rb_define_const(mNewt, "GRID_FLAG_GROWY", INT2FIX(NEWT_GRID_FLAG_GROWY));
  rb_define_const(mNewt, "GRID_EMPTY", INT2FIX(NEWT_GRID_EMPTY));
  rb_define_const(mNewt, "GRID_COMPONENT", INT2FIX(NEWT_GRID_COMPONENT));
  rb_define_const(mNewt, "GRID_SUBGRID", INT2FIX(NEWT_GRID_SUBGRID));

  rb_define_const(mNewt, "KEY_UP", INT2FIX(NEWT_KEY_UP));
  rb_define_const(mNewt, "KEY_DOWN", INT2FIX(NEWT_KEY_DOWN));
  rb_define_const(mNewt, "KEY_LEFT", INT2FIX(NEWT_KEY_LEFT));
  rb_define_const(mNewt, "KEY_RIGHT", INT2FIX(NEWT_KEY_RIGHT));
  rb_define_const(mNewt, "KEY_BKSPC", INT2FIX(NEWT_KEY_BKSPC));
  rb_define_const(mNewt, "KEY_DELETE", INT2FIX(NEWT_KEY_DELETE));
  rb_define_const(mNewt, "KEY_HOME", INT2FIX(NEWT_KEY_HOME));
  rb_define_const(mNewt, "KEY_END", INT2FIX(NEWT_KEY_END));
  rb_define_const(mNewt, "KEY_UNTAB", INT2FIX(NEWT_KEY_UNTAB));
  rb_define_const(mNewt, "KEY_PGUP", INT2FIX(NEWT_KEY_PGUP));
  rb_define_const(mNewt, "KEY_PGDN", INT2FIX(NEWT_KEY_PGDN));
  rb_define_const(mNewt, "KEY_INSERT", INT2FIX(NEWT_KEY_INSERT));

  rb_define_const(mNewt, "KEY_F1", INT2FIX(NEWT_KEY_F1));
  rb_define_const(mNewt, "KEY_F2", INT2FIX(NEWT_KEY_F2));
  rb_define_const(mNewt, "KEY_F3", INT2FIX(NEWT_KEY_F3));
  rb_define_const(mNewt, "KEY_F4", INT2FIX(NEWT_KEY_F4));
  rb_define_const(mNewt, "KEY_F5", INT2FIX(NEWT_KEY_F5));
  rb_define_const(mNewt, "KEY_F6", INT2FIX(NEWT_KEY_F6));
  rb_define_const(mNewt, "KEY_F7", INT2FIX(NEWT_KEY_F7));
  rb_define_const(mNewt, "KEY_F8", INT2FIX(NEWT_KEY_F8));
  rb_define_const(mNewt, "KEY_F9", INT2FIX(NEWT_KEY_F9));
  rb_define_const(mNewt, "KEY_F10", INT2FIX(NEWT_KEY_F10));
  rb_define_const(mNewt, "KEY_F11", INT2FIX(NEWT_KEY_F11));
  rb_define_const(mNewt, "KEY_F12", INT2FIX(NEWT_KEY_F12));
}
