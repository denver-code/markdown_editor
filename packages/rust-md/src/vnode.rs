use serde::{Deserialize, Serialize};

#[derive(PartialEq, Eq, Deserialize, Serialize, Default, Debug)]
pub struct VNode {
    /// selector, e.g. div#unique-id.some.class
    #[serde(skip_serializing_if = "Option::is_none")]
    pub sel: Option<String>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub data: Option<VNodeData>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub children: Option<Vec<VNode>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub text: Option<String>,
}

impl VNode {
    pub fn text_node(string: String) -> Self {
        Self {
            text: Some(string),
            ..Default::default()
        }
    }
}

#[derive(PartialEq, Eq, Deserialize, Serialize, Default, Debug)]
pub struct VNodeData {
    // /// str -> str
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pub props: Option<serde_json::Value>,
    /// str -> str
    pub attrs: Option<serde_json::Value>,
    // /// str -> bool
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pub class: Option<serde_json::Value>,
    // /// str -> str
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pub style: Option<serde_json::Value>,
    // /// str -> str
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pub dataset: Option<serde_json::Value>,
    // /// string | number | symbol
    // #[serde(skip_serializing_if = "Option::is_none")]
    // pub key: Option<serde_json::Value>,
}

#[inline]
pub fn borrow_children(opt: &mut Option<VNode>) -> Option<&mut Vec<VNode>> {
    match opt {
        Some(VNode { children, .. }) => children.as_mut(),
        _ => None,
    }
}