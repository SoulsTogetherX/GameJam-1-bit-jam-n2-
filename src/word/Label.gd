extends Label

signal changeTxt(str : String);

func _on_change_txt(str_) -> void:
	text = str_;
