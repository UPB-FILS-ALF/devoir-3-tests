"use strict";

let assert = require ('assert');
let util = require ('util');

let originalFile = process.argv[2];
let verifyFile = process.argv[3];

let originalTree;
let verifyTree;

try
{
	if (originalFile[0] !== '/') originalFile = './'+originalFile;
	originalTree = require (originalFile);
}
catch (e)
{
	console.error ('Cannot load original AST from '+originalFile);
	process.exit (-1);
}

try
{
	if (verifyFile[0] !== '/') verifyFile = './'+verifyFile;
	verifyTree = require (verifyFile);
}
catch (e)
{
	console.error ('Cannot load AST from '+verifyFile);
	process.exit (-1);
}

if (!originalTree.errors)
{
	assert.deepStrictEqual (originalTree, verifyTree);
}
else
{
	if (Array.isArray (verifyTree.errors))
	{
		if (originalTree.errors.length === verifyTree.errors.length) {
			for (let error of originalTree.errors) {
				let gotit = false;
				for (let err of verifyTree.errors) {
					if (error.id === err.id && error.line === err.line && error.position === err.position) {
						gotit = true;
					}
				}
				if (gotit === false) {
					console.log (`You did not report ${JSON.stringify (error)}`);
					process.exit (1);
				}
			}
		}
		else
		{
			console.log (`There should be ${originalTree.errors.length} errors, you reported  ${verifyTree.errors.length}`);
			process.exit (1);
		}
		
	}
	else
	{
		console.log (`Errors should be an array, you have ${typeof (verifyTree.errors)}`);
		process.exit (1);
	}
}



