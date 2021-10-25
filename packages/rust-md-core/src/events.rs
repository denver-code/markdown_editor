use pulldown_cmark::{Alignment, CodeBlockKind, Event, Tag};

pub fn remap_table_headers<'a>(
    events: impl Iterator<Item = Event<'a>>,
) -> impl Iterator<Item = Event<'a>> {
    events.scan(false, |in_header, event| match event {
        Event::Start(Tag::TableHead) => {
            *in_header = true;
            Some(Event::Start(Tag::TableRow))
        }
        Event::End(Tag::TableHead) => {
            *in_header = false;
            Some(Event::End(Tag::TableRow))
        }
        Event::Start(Tag::TableCell) if *in_header => Some(Event::Start(Tag::TableHead)),
        Event::End(Tag::TableCell) if *in_header => Some(Event::End(Tag::TableHead)),
        e => Some(e),
    })
}

pub fn wrap_code_block<'a>(
    events: impl Iterator<Item = Event<'a>>,
) -> impl Iterator<Item = Event<'a>> {
    events.scan(false, |in_pre, event| match event {
        Event::Start(Tag::CodeBlock(_)) => {
            *in_pre = true;
            Some(event)
        }
        Event::End(Tag::CodeBlock(_)) => {
            *in_pre = false;
            Some(event)
        }
        Event::Text(contents) if *in_pre => Some(Event::Code(contents)),
        e => Some(e),
    })
}

pub fn display_of(tag: &Tag) -> &'static str {
    match tag {
        Tag::Paragraph => "p",
        Tag::Heading(lvl) => match lvl {
            1 => "h1",
            2 => "h2",
            3 => "h3",
            4 => "h4",
            5 => "h5",
            6 => "h6",
            _ => unreachable!(),
        },
        Tag::BlockQuote => "blockquote",
        Tag::CodeBlock(_) => "pre",
        Tag::List(Some(_)) => "ol",
        Tag::List(None) => "ul",
        Tag::Item => "li",
        Tag::Table(_) => "table",
        Tag::TableHead => "th",
        Tag::TableRow => "tr",
        Tag::TableCell => "td",
        Tag::Emphasis => "em",
        Tag::Strong => "strong",
        Tag::Strikethrough => "s",
        Tag::Link(..) => "a",
        Tag::Image(..) => "img",
        _ => "span", // comment
    }
}

pub fn class_of(tag: &Tag) -> Option<String> {
    match tag {
        Tag::CodeBlock(CodeBlockKind::Fenced(lang)) => Some(lang.to_string()),
        _ => None,
    }
}

pub type AlignmentMemo = (Vec<Alignment>, usize);

pub fn attrs_of(
    tag: Tag,
    (alignments, align_index): &mut AlignmentMemo,
) -> Option<(&'static str, String)> {
    match tag {
        Tag::Link(typ, dest, _title) => {
            let href: String = match typ {
                pulldown_cmark::LinkType::Email => format!("mailto:{}", &dest),
                _ => dest.to_string(),
            };
            Some(("href", href))
        }
        Tag::TableCell | Tag::TableHead => {
            let align = alignments[*align_index];
            *align_index = (*align_index + 1) % alignments.len();
            alignment_of(&align).map(|align| ("align", align.to_owned()))
        }
        Tag::Table(aligns) => {
            *alignments = aligns;
            *align_index = 0;
            None
        }
        Tag::List(Some(start)) => Some(("start", start.to_string())),
        _ => None,
    }
}

fn alignment_of(alignment: &Alignment) -> Option<&'static str> {
    match alignment {
        Alignment::None => None,
        Alignment::Left => Some("left"),
        Alignment::Right => Some("right"),
        Alignment::Center => Some("center"),
    }
}
