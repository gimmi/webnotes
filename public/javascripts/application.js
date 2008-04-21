// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function resizeTextArea(textArea)
{
    textArea.rows = textArea.value.split('\n').length + 1;
}