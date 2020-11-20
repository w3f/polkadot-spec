#[macro_use]
extern crate serde;

#[macro_use]
mod macros;

mod builder;
mod cli;
mod command;
mod executor;
mod primitives;
mod tool_spec;

pub use command::run;

pub type Result<T> = std::result::Result<T, failure::Error>;
