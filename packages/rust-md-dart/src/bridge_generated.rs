#![allow(
    non_camel_case_types,
    unused,
    clippy::redundant_closure,
    clippy::useless_conversion
)]
// AUTO GENERATED FILE, DO NOT EDIT.
// Generated by `flutter_rust_bridge`.

use crate::api::*;
use flutter_rust_bridge::*;

// Section: wire functions

#[no_mangle]
pub extern "C" fn wire_parse(port: i64, markdown: *mut wire_uint_8_list) {
    FLUTTER_RUST_BRIDGE_HANDLER.wrap(
        WrapInfo {
            debug_name: "parse",
            port,
            mode: FfiCallMode::Normal,
        },
        move || {
            let api_markdown = markdown.wire2api();
            move |task_callback| parse(api_markdown)
        },
    );
}

// Section: wire structs

#[repr(C)]
#[derive(Clone)]
pub struct wire_uint_8_list {
    ptr: *mut u8,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_element {
    ptr: *mut wire_Element,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Element {
    tag: *mut wire_uint_8_list,
    attributes: *mut wire_list_attribute,
    children: *mut wire_list_element,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_list_attribute {
    ptr: *mut wire_Attribute,
    len: i32,
}

#[repr(C)]
#[derive(Clone)]
pub struct wire_Attribute {
    key: *mut wire_uint_8_list,
    value: *mut wire_uint_8_list,
}

// Section: allocate functions

#[no_mangle]
pub extern "C" fn new_uint_8_list(len: i32) -> *mut wire_uint_8_list {
    let ans = wire_uint_8_list {
        ptr: support::new_leak_vec_ptr(Default::default(), len),
        len,
    };
    support::new_leak_box_ptr(ans)
}

#[no_mangle]
pub extern "C" fn new_list_element(len: i32) -> *mut wire_list_element {
    let wrap = wire_list_element {
        ptr: support::new_leak_vec_ptr(<wire_Element>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

#[no_mangle]
pub extern "C" fn new_list_attribute(len: i32) -> *mut wire_list_attribute {
    let wrap = wire_list_attribute {
        ptr: support::new_leak_vec_ptr(<wire_Attribute>::new_with_null_ptr(), len),
        len,
    };
    support::new_leak_box_ptr(wrap)
}

// Section: impl Wire2Api

pub trait Wire2Api<T> {
    fn wire2api(self) -> T;
}

impl Wire2Api<String> for *mut wire_uint_8_list {
    fn wire2api(self) -> String {
        let vec: Vec<u8> = self.wire2api();
        String::from_utf8_lossy(&vec).into_owned()
    }
}

impl Wire2Api<Vec<u8>> for *mut wire_uint_8_list {
    fn wire2api(self) -> Vec<u8> {
        unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        }
    }
}

impl Wire2Api<u8> for u8 {
    fn wire2api(self) -> u8 {
        self
    }
}

impl Wire2Api<Option<Vec<Element>>> for *mut wire_list_element {
    fn wire2api(self) -> Option<Vec<Element>> {
        if self.is_null() {
            None
        } else {
            Some(self.wire2api())
        }
    }
}

impl Wire2Api<Vec<Element>> for *mut wire_list_element {
    fn wire2api(self) -> Vec<Element> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<Element> for wire_Element {
    fn wire2api(self) -> Element {
        Element {
            tag: self.tag.wire2api(),
            attributes: self.attributes.wire2api(),
            children: self.children.wire2api(),
        }
    }
}

impl Wire2Api<Option<Vec<Attribute>>> for *mut wire_list_attribute {
    fn wire2api(self) -> Option<Vec<Attribute>> {
        if self.is_null() {
            None
        } else {
            Some(self.wire2api())
        }
    }
}

impl Wire2Api<Vec<Attribute>> for *mut wire_list_attribute {
    fn wire2api(self) -> Vec<Attribute> {
        let vec = unsafe {
            let wrap = support::box_from_leak_ptr(self);
            support::vec_from_leak_ptr(wrap.ptr, wrap.len)
        };
        vec.into_iter().map(Wire2Api::wire2api).collect()
    }
}

impl Wire2Api<Attribute> for wire_Attribute {
    fn wire2api(self) -> Attribute {
        Attribute {
            key: self.key.wire2api(),
            value: self.value.wire2api(),
        }
    }
}

// Section: impl NewWithNullPtr

pub trait NewWithNullPtr {
    fn new_with_null_ptr() -> Self;
}

impl<T> NewWithNullPtr for *mut T {
    fn new_with_null_ptr() -> Self {
        std::ptr::null_mut()
    }
}

impl NewWithNullPtr for wire_Element {
    fn new_with_null_ptr() -> Self {
        Self {
            tag: std::ptr::null_mut(),
            attributes: std::ptr::null_mut(),
            children: std::ptr::null_mut(),
        }
    }
}

impl NewWithNullPtr for wire_Attribute {
    fn new_with_null_ptr() -> Self {
        Self {
            key: std::ptr::null_mut(),
            value: std::ptr::null_mut(),
        }
    }
}

// Section: impl IntoDart

impl support::IntoDart for Element {
    fn into_dart(self) -> support::DartCObject {
        vec![
            self.tag.into_dart(),
            self.attributes.into_dart(),
            self.children.into_dart(),
        ]
        .into_dart()
    }
}

impl support::IntoDart for Attribute {
    fn into_dart(self) -> support::DartCObject {
        vec![self.key.into_dart(), self.value.into_dart()].into_dart()
    }
}

// Section: executor
support::lazy_static! {
    pub static ref FLUTTER_RUST_BRIDGE_HANDLER: support::DefaultHandler = Default::default();
}
